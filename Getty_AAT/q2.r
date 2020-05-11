################################################################################################################

# author: ETH Zurich, gta digital, Matteo Lorenzini
# license: please refer to the license.txt file in our git repository (https://github.com/gtadigital/GeoWrapper) 

################################################################################################################



library(SPARQL)
library(ggplot2)
library(reshape)
library(scales)
library(gridExtra)



endpoint <- "http://vocab.getty.edu/sparql"

#Q2 -   Number of triples per CLARIN graph

q <- "SELECT DISTINCT ?label  (count(?concept_label_en) AS ?EN) (count(?concept_label_de)AS ?DE) (count(?concept_label_it) AS ?IT) (count(?concept_label_fr)AS ?FR)
  {
  ?facet a gvp:Facet;
           ##gvp:prefLabelGVP/xl:literalForm ?label;
           skos:inScheme aat:;
           gvp:prefLabelGVP ?prefLabel.
  ?prefLabel xl:literalForm ?label.
  ?concept gvp:broaderPreferred+ ?facet.
         
        OPTIONAL {{ ?concept xl:prefLabel ?concept_labelEN.?concept_labelEN gvp:term ?concept_label_en.} FILTER langMatches(lang(?concept_label_en), 'en').}
        OPTIONAL {{ ?concept xl:prefLabel ?concept_labelDE.?concept_labelDE gvp:term ?concept_label_de.} FILTER langMatches(lang(?concept_label_de), 'de').}
        OPTIONAL {{ ?concept xl:prefLabel ?concept_labelIT.?concept_labelIT gvp:term ?concept_label_it.} FILTER langMatches(lang(?concept_label_it), 'it').}
        OPTIONAL {{ ?concept xl:prefLabel ?concept_labelFR.?concept_labelFR gvp:term ?concept_label_fr.} FILTER langMatches(lang(?concept_label_fr), 'fr').}

}

GROUP BY ?label
  "

res <- SPARQL(url=endpoint, q)$results

p1 <- ggplot(res, aes(x=reorder(label, -EN), 
y=EN, fill=label)) + theme_bw() + geom_bar(stat='identity') + 
theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) + 
ggtitle('EN') + 
labs(x='Facet'	, y='Concepts') + theme(legend.position='none')

p2 <- ggplot(res, aes(x=reorder(label, -DE), 
y=DE, fill=label)) + theme_bw() + geom_bar(stat='identity') + 
theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) + 
ggtitle('DE') + 
labs(x='Facet'	, y='Concepts') + theme(legend.position='none')

p3 <- ggplot(res, aes(x=reorder(label, -IT), 
y=IT, fill=label)) + theme_bw() + geom_bar(stat='identity') + 
theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) + 
ggtitle('IT') + 
labs(x='Facet'	, y='Concepts') + theme(legend.position='none')

p4 <- ggplot(res, aes(x=reorder(label, -FR), 
y=FR, fill=label)) + theme_bw() + geom_bar(stat='identity') + 
theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) + 
ggtitle('FR') + 
labs(x='Facet'	, y='Concepts') + theme(legend.position='none')

grid.arrange(p1,p2,p3,p4, ncol = 2, nrow = 2)