
library(SPARQL)
library(ggplot2)
library(reshape)
library(scales)
endpoint <- "http://vocab.getty.edu/sparql"


q <- "SELECT ?facet ?label (count (?concept)as ?concept_NR) {
  ?facet a gvp:Facet;
           gvp:prefLabelGVP/xl:literalForm ?label;
           skos:inScheme aat:.
           
  ?concept gvp:broaderPreferred+ ?facet
}

GROUP BY ?facet ?label
  "

res <- SPARQL(url=endpoint, q)$results


ggplot(res, aes(x=reorder(label, -concept_NR), 
y=concept_NR, fill=label)) + theme_bw() + geom_bar(stat='identity') + 
theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) + 
ggtitle('All the facets from AAT thesaurus with the number of the direct sub-concepts') + 
labs(x='Facet'	, y='Nr of direct concepts') + theme(legend.position='none')