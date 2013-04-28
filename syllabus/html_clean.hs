
import Text.Pandoc

{-
This script uses the Pandoc library to do the transformations
needed on the way from my mixed markdown/LaTeX syllabus sources to a
single HTML file: 

1. Transform the slightly garbled html produced by tex4ht from LaTeX
source containing a biblatex bibliography by getting rid of definition
lists and replacing them with regular old paragraphs. This will eat any
other dl's in the source, so beware. 

2. Reduce header levels from h3 to h2, h2 to h1 as needed.

3. Strip out the contentless <p></p> pairs tex4ht produces, in some obscure way, after non-paragraph block elements.

The script is a standard filter: input on stdin, output on stdout.

See <http://andrewgoldstone.com/blog/http://andrewgoldstone.com/blog/2013/02/12/4htweak> and <http://andrewgoldstone.com/blog/http://andrewgoldstone.com/blog/2013/04/21/more-on-pandoc>.
-}

-- decrement header levels
reduce_header :: Block -> Block
reduce_header (Header n attr xs) = (Header n' attr xs)
    where n' = if (n > 1) then (n - 1) else n
reduce_header x = x

-- extract and flatten the dd's, throwing out the dt's
-- DefinitionList [([Inline], [[Block]])]
-- Each list item is a pair consisting of a term (a list of inlines) and
-- one or more definitions (each a list of blocks) 
flatten_dl :: Block -> [Block]
flatten_dl (DefinitionList items) = (concat $ map (concat . snd) items)
flatten_dl x = [x]

clean_dls :: [Block] -> [Block]
clean_dls (dl@(DefinitionList items):bs)
    = (flatten_dl dl) ++ (clean_dls bs)
clean_dls (b:bs) = b:(clean_dls bs)
clean_dls [] = []

-- tex4ht's html tends to put empty paragraphs after various block
-- elements. A bunch of <p></p> pairs aren't really a problem, but
-- wordpress hates them, so let's throw 'em out
strip_empty_paras :: [Block] -> [Block]
strip_empty_paras = filter (/=(Para []))

-- two passes needed because not all the transformations have the same
-- type and so can't be lifted by a single bottomUp
tx_pandoc :: Pandoc -> Pandoc
tx_pandoc = (bottomUp (clean_dls . strip_empty_paras)) . (bottomUp reduce_header)

-- ensure smart quotes
main = interact
        (writeHtmlString def
        . tx_pandoc
        . readHtml def{readerSmart=True})

