#import "template.typ": project, codefigure, hr, quote, note, weakbreak, caption_with_source

#show: project.with(
  // 'de' for german or 'en' for english.
  // Pull Requests for other languages are welcome! :)
  lang: "de",

  // Shows a line for a signature, if set to `false`,
  is_digital: true,

  // Display the confidentiality clause
  confidentiality_clause: false,

  ///
  /// Cover Sheet
  ///
  // Full title of your project
  title_long: "Evaluierung von Chunking-Strategien und Metadatenextraktion für die Performance-Optimierung von RAG-Pipelines",
  // Shortened title, which is displayed in the header on every page
  title_short: "Evaluierung von Chunking-Strategien für RAG-Pipelines",
  // The type of your project
  thesis_type: "Project Thesis 2",
  // Other information about you and your project
  firstname: "Lukas",
  lastname: "Gröning",
  signature_place: "Mannheim",
  matriculation_number: "3826448",
  course: "WWI24SEA",
  submission_date: "16th Februar 2026",
  processing_period: "17th November 2025 - 16th Februar 2026",
  supervisor_company: "Bastian Seeger",
  supervisor_university: "Aaron Schweig",

  // Disable the abstract by changing to `abstract: ()`
  // To load the abstract from a file use include("abstract.typ") instead of [...]`
  // If you only want one language, leave the comma at the end -> `("de", "Deutsch", []),` its necessary for syntax of the template
  abstract: (
    ("de", "Deutsch", include "abstracts/abstract_german.typ"),
  ),

  // appendices: usage: ("Title", [content], "label")
  // change to `appendices: none` to remove appendix
  appendices: (
    // ("Appendix Titel 1", include("appendix.typ"), "appendix-1"), // appendix from file

  ),

  // Path/s to references - either .yaml or .bib files
  // * for `.yaml` files see: [hayagriva](https://github.com/typst/hayagriva)
  library_paths: "literature.bib",

  // Specify acronyms here.
  // The key is used to reference the acronym.
  // The short form is used every time and the long form is used
  // additionally the first time you reference the acronym.
  glossary_entries: (
    (key: "RAG", short: "RAG", description: "Retrieval-Augmented Generation: Eine Technik, bei der ein Large Language Model mit einer externen Wissensdatenbank kombiniert wird, um präzisere und faktisch korrekte Antworten zu generieren"),
    
    (key: "Chunking", short: "Chunking", description: "Der Prozess der Aufteilung großer Textdokumente in kleinere, semantisch zusammenhängende Abschnitte (Chunks), um die Effizienz und Genauigkeit der Informationsretrieval zu verbessern"),
    
    (key: "Embedding", short: "Embedding", description: "Vektorielle Repräsentation von Text in einem hochdimensionalen Raum, wobei semantisch ähnliche Texte nahe beieinander liegen. Wird für semantische Suche in RAG-Systemen verwendet"),
    
    (key: "VectorDB", short: "Vector Database", description: "Eine spezialisierte Datenbank zur effizienten Speicherung und Suche von Vektoren (Embeddings), z.B. Pinecone, Weaviate oder ChromaDB"),
    
    (key: "LLM", short: "LLM", description: "Large Language Model: Ein auf großen Textmengen trainiertes neuronales Netzwerk, das natürliche Sprache verstehen und generieren kann, z.B. GPT-4 oder Claude"),
    
    (key: "SemanticSearch", short: "Semantic Search", description: "Suchverfahren, das die Bedeutung und den Kontext von Anfragen berücksichtigt, anstatt nur exakte Wortübereinstimmungen zu finden"),
    
    (key: "ContextWindow", short: "Context Window", description: "Die maximale Anzahl an Tokens, die ein LLM gleichzeitig verarbeiten kann, typischerweise zwischen 4k und 128k Tokens"),
  ),
  acronyms: (
    (key:"EX", short: "EX", long: "Example"),
  ),
)

// You can now start writing :)

= Einleitung

== Motivation

Die rasante Entwicklung großer Sprachmodelle (Large Language Models, LLMs) hat in den vergangenen Jahren zu einem fundamentalen Wandel in der Verarbeitung natürlicher Sprache geführt. Modelle wie GPT-4, Claude oder LLaMA demonstrieren beeindruckende Fähigkeiten in der Textgenerierung, Informationsextraktion und im logischen Schlussfolgern. Trotz dieser Fortschritte zeigen LLMs jedoch systematische Schwächen: Sie neigen zu faktisch falschen Ausgaben, sogenannten Halluzinationen, verfügen über kein Wissen jenseits ihres Trainingszeitpunkts und können unternehmensspezifische Informationen nicht ohne weiteres verarbeiten @lewis2020retrieval.

Retrieval-Augmented Generation (RAG) hat sich als prominenter Architekturansatz etabliert, um diese Limitierungen zu adressieren. Durch die Kombination von parametrischem Wissen des LLMs mit nicht-parametrischem Wissen aus einer externen Wissensdatenbank können RAG-Systeme aktuelle, domänenspezifische und nachvollziehbare Antworten generieren @lewis2020retrieval. Bis 2023 haben führende Technologieunternehmen RAG-basierte Systeme in Suchmaschinen, virtuelle Assistenten und Enterprise-Anwendungen integriert, wodurch RAG zu einem zentralen Architekturmuster für den produktiven Einsatz von KI in Unternehmen geworden ist @oche2025systematic. Dies ist insbesondere dort relevant, wo Faktentreue, Nachvollziehbarkeit und die Integration proprietärer Datenbestände kritische Anforderungen darstellen.
[TODO Schaeffler Bezug außenvor gelassen]

Die Performance von RAG-Systemen wird maßgeblich durch die Qualität der Retrieval-Komponente bestimmt. Ein wichtiger Aspekt ist dabei das Chunking, die Segmentierung von Dokumenten in retrievalbare Einheiten. Die Wahl der Chunking-Strategie beeinflusst unmittelbar die Retrieval-Qualität und damit die Gesamtperformance des Systems: Größe, Inhalt und semantische Grenzen der Chunks bestimmen, welche Informationen dem LLM als Kontext zur Verfügung stehen und wie präzise semantische Repräsentationen die Dokumentstruktur abbilden können @weaviate2024chunking. 

Während die Forschung zu Embeddings und Retrieval-Algorithmen intensiv vorangetrieben wird, besteht eine erhebliche Forschungslücke hinsichtlich systematischer Untersuchungen unterschiedlicher Chunking-Strategien. Praktiker berichten von einem Mangel an klarer, evidenzbasierter Orientierung zur optimalen Dokumentsegmentierung für verschiedene Anwendungsfälle @Databricks2025Chunking. Diese Lücke ist von erheblicher praktischer Relevanz: Unternehmen investieren substanzielle Ressourcen in die Implementierung von RAG-Systemen, ohne auf systematische Erkenntnisse zur Performance-Optimierung durch Chunking zurückgreifen zu können.

Die vorliegende Arbeit adressiert diese Lücke durch eine systematische Evaluation verschiedener Chunking-Strategien und deren Einfluss auf die Retrieval-Performance sowie die Qualität der generierten Antworten in einem praxisnahen Unternehmenskontext.

== Zielsetzung und Forschungsfrage

Die aufgezeigte Forschungslücke motiviert die zentrale Zielsetzung dieser Arbeit. Ziel dieser Arbeit ist die systematische Evaluation verschiedener Chunking-Strategien und deren Einfluss auf die Performance von RAG-Systemen. Konkret wird untersucht, wie unterschiedliche Ansätze zur des Chunkings die Qualität des Retrievals und damit die Akkuratheit der generierten Antworten beeinflussen.

Daraus ergibt sich folgende *zentrale Forschungsfrage*:
Wie beeinflussen unterschiedliche Chunking-Strategien die Retrieval-Qualität und die Akkuratheit der generierten Antworten in einem RAG-System?

Die Untersuchung erfolgt anhand eines praxisnahen Unternehmensdatensatzes bei Schaeffler und zielt darauf ab, evidenzbasierte Handlungsempfehlungen für die Auswahl und Konfiguration von Chunking-Strategien abzuleiten.

== Abgrenzung und Randbedingungen


== Aufbau der Arbeit 

= Theoretische Grundlagen von RAG-Systemen
== Die RAG-Architektur
Retrieval-Augmented Generation (RAG) bezeichnet ein hybrides Architekturmodell, das die Stärken von Large Language Models (LLMs) mit den Vorteilen von Information-Retrieval-Systemen kombiniert. Die zentrale Idee besteht darin, dass ein vortrainiertes generatives Sprachmodell nicht ausschließlich auf sein internes, parametrisches Wissen angewiesen ist, sondern zur Laufzeit auf eine externe, nicht-parametrische Wissensbasis zugreifen kann. Dadurch wird das Modell in die Lage versetzt, aktuelle, spezifische und verifizierbare Informationen in seine Antworten einzubinden, ohne dass eine aufwendige Neutrainierung erforderlich ist @lewis2020retrieval.

=== Grundprinzip und Motivation
Traditionelle LLMs speichern Faktenwissen implizit in ihren Modellparametern. Dies führt zu mehreren bekannten Limitationen: Erstens kann das Wissen veraltet sein, da es auf dem Zeitpunkt des letzten Trainings basiert. Zweitens neigen LLMs dazu, bei fehlenden oder unsicheren Informationen plausibel klingende, aber faktisch falsche Aussagen zu generieren – ein Phänomen, das als „Halluzination" bezeichnet wird. Drittens ist eine Aktualisierung des Wissens nur durch kostspielige Nachtrainings möglich @lewis2020retrieval.
RAG adressiert diese Probleme durch die Entkopplung von Wissensrepräsentation und Textgenerierung: Das parametrische Wissen des LLMs wird durch eine externe Dokumentensammlung ergänzt, aus der zur Laufzeit relevante Textpassagen abgerufen werden. Diese Passagen dienen dann als Kontext für die Generierung der Antwort. Dadurch kombiniert RAG die Flexibilität und sprachliche Kompetenz großer Sprachmodelle mit der Präzision und Aktualität von Retrieval-Systemen @lewis2020retrieval.

=== Architekturkomponenten
Die RAG-Architektur besteht konzeptionell aus drei Hauptkomponenten (siehe Abbildung in Oche et al., 2025)
#figure(
  image("RAG-Oche.png", width: 100%),
  caption: [
    Schematische Darstellung der RAG-Architektur. 
    Das Diagramm illustriert den Informationsfluss vom Retrieval relevanter Dokumente bis zur Generierung der Antwort. 
    Quelle: Entnommen aus @oche2025systematic.
  ],
) <rag_architektur>

- *Retrieval-Komponente (Retriever)*: Diese Komponente ist für die Identifikation und Extraktion relevanter Dokumente oder Textpassagen aus einer umfangreichen Wissensbasis zuständig. Moderne RAG-Systeme verwenden in der Regel dichte neuronale Retriever wie Dense Passage Retrieval (DPR), die Anfragen und Dokumente in einen gemeinsamen Vektorraum einbetten und über Ähnlichkeitsmaße die k relevantesten Dokumente identifizieren (Karpukhin et al., 2020).
- *Generierungs-Komponente (Generator)*: Diese Komponente besteht aus einem vortrainierten Sequence-to-Sequence-Modell (z. B. BART oder T5), das die ursprüngliche Anfrage zusammen mit den abgerufenen Dokumenten als Eingabe erhält und darauf basierend eine kohärente Antwort generiert @lewis2020retrieval.
- *Fusionsmechanismus*: Dieser Mechanismus regelt, wie die Information aus mehreren abgerufenen Dokumenten integriert wird. RAG behandelt die Dokumentenauswahl als latente Variable und marginalisiert über verschiedene Dokumente, entweder sequenzbasiert (ein Dokument pro Antwort) oder tokenbasiert (unterschiedliche Dokumente für verschiedene Teile der Antwort) @lewis2020retrieval.

Formal lässt sich die RAG-Wahrscheinlichkeit für eine Ausgabe $y$ gegeben eine Eingabe $x$ wie folgt definieren:

$ P(y | x) = sum_(i=1)^K P_eta(z_i | x) dot P_theta(y | x, z_i) $

Hierbei bezeichnet $P_eta(z_i | x)$ die Wahrscheinlichkeit, dass Dokument $z_i$ für die Anfrage $x$ relevant ist, und $P_theta(y | x, z_i)$ die Wahrscheinlichkeit, dass das generative Modell die Ausgabe $y$ erzeugt, gegeben $x$ und $z_i$. @lewis2020retrieval @oche2025systematic.

=== Funktionsweise im Überblick
Der typische Ablauf in einem RAG-System gliedert sich in folgende Schritte  @oche2025systematic:

- Anfrageverarbeitung: Eine Nutzeranfrage wird durch einen Query-Encoder in eine dichte Vektorrepräsentation transformiert.
- Dokumentenabruf: Mit Hilfe dieser Repräsentation werden die k ähnlichsten Dokumente aus einem vorher indizierten Dokumentenbestand abgerufen (typischerweise über Maximum Inner Product Search, MIPS).
- Kontextvorbereitung: Die abgerufenen Dokumente werden als zusätzlicher Kontext für das generative Modell aufbereitet.
- Antwortgenerierung: Das LLM generiert eine Antwort, indem es sowohl die ursprüngliche Anfrage als auch die abgerufenen Dokumente berücksichtigt.
- Ausgabe: Die finale Antwort wird dem Nutzer präsentiert, optional mit Verweisen auf die verwendeten Quelldokumente.

Diese Architektur ermöglicht es, dass Antworten nicht nur auf dem internen Modellwissen basieren, sondern durch externe, verifizierbare Quellen gestützt werden. Dadurch wird die Faktentreue erhöht und die Transparenz der Antworten verbessert, da Nutzer die Herkunft der Informationen nachvollziehen können. @lewis2020retrieval @oche2025systematic
Vorteile gegenüber rein parametrischen Modellen
Im Vergleich zu rein parametrischen LLMs bietet RAG mehrere entscheidende Vorteile:

Aktualität: Da die Wissensbasis extern vorliegt, kann sie unabhängig vom Modell aktualisiert werden. Dies ist insbesondere in dynamischen Domänen (z. B. Nachrichten, Finanzinformationen) von großer Bedeutung. @lewis2020retrieval
Reduzierung von Halluzinationen: Durch die explizite Verankerung der Generierung in abgerufenen Dokumenten wird die Wahrscheinlichkeit von faktisch falschen Aussagen signifikant reduziert. @lewis2020retrieval @oche2025systematic
Skalierbarkeit des Wissens: Während rein parametrische Modelle durch ihre Parameterzahl begrenzt sind, kann die Wissensbasis eines RAG-Systems beliebig erweitert werden, ohne dass das Modell selbst vergrößert werden muss (Borgeaud et al., 2022). [BIBTEX HINZUFÜGEN TODO: Borgeaud et al., 2022, Improving language models by retrieving from trillions of tokens]
Transparenz und Nachvollziehbarkeit: RAG-Systeme können die verwendeten Quellen explizit angeben, was die Vertrauenswürdigkeit erhöht und eine Überprüfung der Antworten ermöglicht. @lewis2020retrieval


== Die Retrieval-Komponente

=== Aufgabe im RAG-System
Die Retrieval-Komponente bildet das Bindeglied zwischen der Nutzereingabe und der externen Wissensbasis eines RAG-Systems. Ihre zentrale Aufgabe besteht darin, aus einer potenziell sehr großen Dokumentensammlung, diejenigen Textpassagen zu identifizieren und zu extrahieren, die für die Beantwortung einer gegebenen Anfrage am relevantesten sind (Lewis et al., 2020; Karpukhin et al., 2020). Während das generative Sprachmodell für die Formulierung einer kohärenten und sprachlich angemessenen Antwort zuständig ist, liegt die Verantwortung des Retrievers darin, diesem Modell die inhaltlich passenden Informationsquellen bereitzustellen. Diese Arbeitsteilung ist essenziell für die Funktionsweise von RAG-Systemen: Ohne präzises Retrieval erhält das generative Modell entweder irrelevante Kontextinformationen, die zu ungenauen oder themenfremden Antworten führen, oder es muss ausschließlich auf sein internes, parametrisches Wissen zurückgreifen, wodurch die Vorteile der externen Wissensanbindung verloren gehen (Oche et al., 2025). Die Retrieval-Komponente fungiert somit als Filter- und Selektionsmechanismus, der die Suchraumerweiterung drastisch reduziert: Anstatt dass das generative Modell potenziell Millionen von Dokumenten verarbeiten müsste, arbeitet es auf Basis einer kleinen, hochrelevanten Teilmenge – typischerweise zwischen 5 und 100 Textpassagen (Lewis et al., 2020; Karpukhin et al., 2020).

=== Sparse and Dense Retrival
Traditionelle Information-Retrieval-Systeme basieren auf Sparse-Retrieval-Methoden wie TF-IDF (Term Frequency-Inverse Document Frequency) oder BM25 (Best Matching 25), die Dokumente und Anfragen als hochdimensionale, dünn besetzte Vektoren im Vokabularraum repräsentieren (Manning et al., 2008). Diese Verfahren beruhen auf exakter Wortübereinstimmung: Ein Dokument wird als relevant eingestuft, wenn es viele der in der Anfrage enthaltenen Begriffe aufweist. BM25 erweitert diesen Ansatz durch eine probabilistische Gewichtung, die Dokumentlänge und Termfrequenz berücksichtigt und wurde lange Zeit als De-facto-Standard im Open-Domain Question Answering eingesetzt (Robertson & Zaragoza, 2009; Chen et al., 2017). Die Stärke dieser Methoden liegt in ihrer Effizienz und Interpretierbarkeit: Über invertierte Indizes können Millionen von Dokumenten in Millisekunden durchsucht werden, und die Relevanzbewertung ist nachvollziehbar, da sie auf expliziten Stichwortübereinstimmungen basiert.

Allerdings stoßen sparse Methoden an grundlegende Grenzen, wenn es um semantische Ähnlichkeit geht. Anfragen wie "Wer ist der Bösewicht in Herr der Ringe?" und ein Dokument, das von "Sala Baker, der den Schurken Sauron verkörpert" spricht, teilen kaum gemeinsame Terme ("Bösewicht" vs. "Schurke"), obwohl sie inhaltlich perfekt zueinander passen. Synonyme, Paraphrasen und thematisch verwandte Ausdrücke werden von Sparse-Verfahren nicht erkannt, da diese rein auf Oberflächenformen operieren (Karpukhin et al., 2020).

Dense Retrieval adressiert diese Limitationen durch die Verwendung von dichten, niedrigdimensionalen Vektorrepräsentationen, die von neuronalen Netzen gelernt werden. Statt Dokumente und Anfragen als Bag-of-Words zu behandeln, werden sie in einen gemeinsamen, semantischen Vektorraum eingebettet, in dem inhaltlich ähnliche Texte räumlich nahe beieinander liegen – unabhängig von der konkreten Wortwahl (Karpukhin et al., 2020; Oche et al., 2025). Das prominenteste Beispiel für Dense Retrieval im Kontext von RAG ist Dense Passage Retrieval (DPR), das auf einer Dual-Encoder-Architektur basiert: Ein Encoder transformiert die Anfrage in einen Vektor, ein zweiter Encoder transformiert jedes Dokument in einen Vektor, und die Relevanz wird über die Ähnlichkeit dieser Vektoren (typischerweise das Skalarprodukt) bestimmt (Karpukhin et al., 2020).
Der Wechsel von Sparse zu Dense Retrieval stellte einen Paradigmenwechsel dar. Während lange Zeit angenommen wurde, dass Dense-Methoden aufgrund des hohen Trainingsaufwands und der geringeren Interpretierbarkeit nicht mit BM25 konkurrieren könnten, zeigten Karpukhin et al. (2020), dass DPR bei entsprechendem Training BM25 deutlich übertrifft: Die Top-20-Retrieval-Genauigkeit auf Natural Questions stieg von 59% (BM25) auf 78% (DPR). Entscheidend war dabei die Nutzung vortrainierter Sprachmodelle wie BERT, die bereits umfangreiches semantisches Wissen kodieren, sowie ein gezieltes Fine-Tuning auf Frage-Antwort-Paaren (Karpukhin et al., 2020; Lewis et al., 2020). Dense Retrieval ermöglicht es RAG-Systemen somit, präziser und robuster auf natürlichsprachliche Anfragen zu reagieren, was letztlich zu einer höheren Antwortqualität im gesamten System führt.


== Dense Retrieval: Funktionsweise
Dense Passage Retrieval (DPR) basiert auf einer Bi-Encoder-Architektur, die aus zwei unabhängigen neuronalen Encodern besteht: einem Query-Encoder (E_Q(\cdot)) für die Transformation von Anfragen und einem Passage-Encoder (E_P(\cdot)) für die Transformation von Dokumenten oder Textpassagen (Karpukhin et al., 2020). Beide Encoder sind typischerweise vortrainierte Transformer-Modelle wie BERT, die auf die spezifische Retrieval-Aufgabe feinabgestimmt werden. Die zentrale Idee besteht darin, dass beide Encoder Texte in denselben Embedding-Raum abbilden – einen kontinuierlichen, niedrigdimensionalen Vektorraum (üblicherweise 768 Dimensionen bei BERT-base), in dem semantische Ähnlichkeit durch räumliche Nähe repräsentiert wird (Karpukhin et al., 2020; Lewis et al., 2020).

Konkret bedeutet dies: Eine Anfrage wie "Hauptstadt von Frankreich" wird durch $E_Q$ in einen Vektor $bold(q) in RR^d$ transformiert, während jede Passage im Dokumentenkorpus durch $E_P$ in einen Vektor $bold(p)_i in RR^d$ transformiert wird. Entscheidend ist, dass beide Vektoren im gleichen Raum liegen und durch ein Ähnlichkeitsmaß verglichen werden können. DPR verwendet hierfür das Skalarprodukt (auch Dot Product oder inneres Produkt genannt):

$ op("sim")(q, p_i) = bold(q)^top bold(p)_i $
Ein hohes Skalarprodukt indiziert eine hohe Relevanz der Passage (p_i) für die Anfrage (q) (Karpukhin et al., 2020). Die Wahl des Skalarprodukts ist kein Zufall: Es ist recheneffizient und ermöglicht die Verwendung spezialisierter Datenstrukturen für die schnelle Suche (Oche et al., 2025).
Der Embedding-Raum selbst entsteht durch das Training der Encoder auf Paaren von Fragen und relevanten Passagen. Während des Trainings lernen die Modelle, semantisch verwandte Texte näher zusammenzurücken und irrelevante Texte voneinander zu entfernen. Dies geschieht durch eine kontrastive Verlustfunktion, die positive Paare (Frage + korrekte Passage) belohnt und negative Paare (Frage + irrelevante Passage) bestraft (Karpukhin et al., 2020). Das Ergebnis ist ein Raum, in dem nicht nur exakte Wortübereinstimmungen, sondern auch konzeptuelle Ähnlichkeiten erfasst werden – etwa zwischen "Bösewicht" und "Antagonist" oder "Hauptstadt" und "Regierungssitz".
Zur Laufzeit muss das System aus Millionen von Dokumentenvektoren die (k) relevantesten für eine gegebene Anfrage finden. Diese Aufgabe wird als Maximum Inner Product Search (MIPS) bezeichnet: Gesucht sind die (k) Passagen mit den höchsten Skalarprodukt-Werten zu (\mathbf{q}). Eine naive Berechnung aller Skalarprodukte wäre zu langsam (lineare Komplexität in der Korpusgröße), weshalb RAG-Systeme auf spezialisierte Indexierungsstrukturen wie FAISS (Facebook AI Similarity Search) zurückgreifen (Johnson et al., 2017; Lewis et al., 2020). FAISS verwendet approximative Nearest-Neighbor-Algorithmen, die auf Clustering und Vektorquantisierung basieren, und ermöglicht die Suche in Milliarden von Vektoren in Submillisekunden-Bereich (Karpukhin et al., 2020). In der Praxis werden alle Dokumentenvektoren offline vorberechnet und in einem FAISS-Index gespeichert. Eine eingehende Anfrage wird dann in einen Query-Vektor transformiert, und FAISS liefert die (k) nächsten Nachbarn, die anschließend an das generative Modell weitergegeben werden (Lewis et al., 2020; Oche et al., 2025).
Zusammengefasst ermöglicht die Bi-Encoder-Architektur eine effiziente Trennung von Indexierung (offline) und Retrieval (online), während der gemeinsame Embedding-Raum semantische Ähnlichkeit erfasst und MIPS-Algorithmen die praktische Skalierbarkeit auf große Dokumentensammlungen sicherstellen.

== Large Language Models (LLMs)

Large Language Models (LLMs) sind Transformer-basierte autoregressive Sprachmodelle @khandelwal2020generalization, die auf umfangreichen Textkorpora trainiert werden und in der Lage sind, kontextabhängige Vorhersagen für nachfolgende Tokens zu treffen. Diese Modelle speichern während des Trainingsprozesses Faktenwissen in ihren Modellparametern – ein Konzept, das als _parametrisches Wissen_ bezeichnet wird @lewis2020retrieval. Khandelwal et al. khandelwal2020generalization beschreiben die Architektur moderner LLMs am Beispiel eines decoder-only Transformers mit 16 Layern, 16 Self-Attention-Heads und 247 Millionen trainierbaren Parametern. Diese Modelle verarbeiten Kontext in Form von Token-Sequenzen und erzeugen autoregressive Wahrscheinlichkeitsverteilungen über das Vokabular.

Eine zentrale technische Limitation von LLMs ist die _Kontextfenster-Begrenzung_. Transformer-basierte Modelle können nur eine begrenzte Anzahl von Tokens als Eingabe verarbeiten – beispielsweise 3072 Tokens bei WIKITEXT-103 oder 1024 Tokens bei anderen Korpora @khandelwal2020generalization. Diese Beschränkung ergibt sich aus der quadratischen Komplexität des Self-Attention-Mechanismus und stellt eine fundamentale Herausforderung für die Verarbeitung umfangreicher externer Dokumente dar. Wenn externe Wissensspeicher in RAG-Systemen integriert werden sollen, müssen große Dokumente zwangsläufig in kleinere Segmente – sogenannte _Chunks_ – zerlegt werden, um innerhalb des Kontextfensters verarbeitet werden zu können @oche2025systematic. Dies begründet die zentrale Relevanz von Chunking-Strategien für die technische Realisierung von RAG-Systemen.

Ein weiteres Problem von LLMs ist ihre Tendenz zu _Halluzinationen_ – der Generierung von Inhalten, die zwar sprachlich flüssig erscheinen, jedoch faktisch inkorrekt oder nicht überprüfbar sind Ji2024_Hallucination. Ji et al. Ji2024_Hallucination definieren Halluzination als generierte Ausgaben, die entweder der Quellbasis widersprechen (_intrinsische Halluzination_) oder aus der Quellbasis nicht verifizierbar sind (_extrinsische Halluzination_). Dieses Phänomen entsteht, weil LLMs ausschließlich auf ihr parametrisches Wissen angewiesen sind, das aus den Trainingsdaten stammt und daher statisch sowie potenziell veraltet ist @lewis2020retrieval. Lewis et al. @lewis2020retrieval zeigen, dass reine LLM-basierte Generierung bei wissensintensiven Aufgaben zu ungenauen Antworten führen kann, insbesondere wenn die Trainingsdaten das Thema der Anfrage nicht ausreichend abdecken.

Die Unterscheidung zwischen _parametrischem_ und _non-parametrischem Wissen_ ist für das Verständnis von RAG-Systemen essentiell. Parametrisches Wissen ist in den Modellgewichten kodiert und kann nur durch erneutes Training aktualisiert werden, während non-parametrisches Wissen in Form externer Textkorpora vorliegt und zur Laufzeit über Retrieval-Mechanismen zugänglich gemacht werden kann @lewis2020retrieval, @oche2025systematic. RAG-Systeme nutzen diese Dualität, indem sie die generativen Fähigkeiten von LLMs mit der Flexibilität externer Wissensspeicher kombinieren. Der Generator konditioniert seine Ausgabe nicht nur auf die Eingabeanfrage, sondern auch auf die abgerufenen externen Dokumente, wodurch die Generierung auf aktuellem und verifizierbarem Wissen basiert @lewis2020retrieval. Diese Architektur adressiert sowohl die Problematik veralteten Wissens als auch die Neigung zu Halluzinationen, indem sie dem Modell explizite Kontextinformationen bereitstellt.

Die Kontextfenster-Limitation stellt somit die technische Notwendigkeit dar, externe Dokumente zu segmentieren, bevor sie einem LLM als Kontext zugeführt werden können. Die Art und Weise dieser Segmentierung – die Wahl der Chunking-Strategie – beeinflusst unmittelbar, welche Informationen dem Modell zur Verfügung stehen und wie kohärent diese Informationen präsentiert werden. Dies erklärt, warum Chunking-Strategien eine zentrale Rolle für die Performance von RAG-Systemen spielen und im Fokus dieser Arbeit stehen.

= Preprocessing
Die Transformation von Rohdokumenten in strukturierte, maschinenlesbare Repräsentationen bildet die Grundlage jedes RAG-Systems. Dieser Prozess umfasst zwei zentrale Schritte: die Dokumentenvorbereitung, welche heterogene Eingabeformate in einheitliche Textrepräsentationen überführt, und das Chunking, das diese Texte in semantisch kohärente Einheiten für das Retrieval segmentiert. Beide Preprocessing-Schritte beeinflussen maßgeblich die Qualität nachgelagerter Retrieval- und Generierungsprozesse.
== Dokumentenvorbereitung und -transformation
Dokumente in unstrukturierten und semi-strukturierten Formaten wie PDF, DOCX oder HTML müssen zunächst in maschinenlesbare Textrepräsentationen konvertiert werden, bevor sie für RAG-Systeme nutzbar sind. Diese Transformation stellt eine nicht-triviale Herausforderung dar, da Dokumentenformate primär auf visuelle Darstellung optimiert sind und ihre ursprüngliche semantische Struktur nur implizit enkodieren.
Herausforderungen der Dokumentenextraktion
Document Parsing – die Konvertierung von visuell strukturierten Dokumenten in strukturierte, maschinenlesbare Daten – ist besonders für PDF-Dokumente problematisch. PDF ist ein Format, das "nur Anweisungen für die Zeichenposition von Zeichen und Linien speichert" @Zhang2024_DocParsing[S. 1], jedoch keine explizite Textstruktur bereithält. Dies führt zu mehreren technischen Herausforderungen:
Layout-Komplexität: Dokumente können komplexe mehrspaltige Layouts, verschachtelte Strukturen, Tabellen und mathematische Ausdrücke enthalten. Die akkurate Identifikation struktureller Elemente – wie Textblöcke, Absätze, Überschriften oder Abbildungen – sowie deren räumliche Koordinaten und Lesereihenfolge erfordert spezialisierte Layout-Erkennungsverfahren @Zhang2024_DocParsing[S. 5]. Regelbasierte Ansätze zur Bestimmung der Lesereihenfolge versagen bei verschachtelten Strukturen wie mehrstufigen Überschriften oder mehrspaltigen Layouts @Zhang2024_DocParsing[S. 21].
Texterkennung und OCR: Für gescannte Dokumente ist Optical Character Recognition (OCR) erforderlich, um visuellen Text in maschinenlesbare Zeichen zu konvertieren @Zhang2024_DocParsing[S. 7]. Hierbei treten Fehler bei dicht gesetztem Text, unterschiedlichen Schriftarten oder minderwertiger Scanqualität auf. Selbst bei digital erstellten PDFs können Font-Encoding-Probleme die Extraktion beeinträchtigen, da nicht alle Schriftarten direkt auf Unicode abbildbar sind.
Strukturverlust: Bei der Konvertierung in reinen Text gehen häufig relevante Strukturinformationen verloren – etwa Überschriftenhierarchien, Absatzgrenzen oder die Zuordnung von Abbildungen zu ihren Bildunterschriften. Roy et al. demonstrieren empirisch, dass unterschiedliche Preprocessing-Entscheidungen – beispielsweise die Behandlung von HTML-Tags oder JavaScript – erhebliche Auswirkungen auf die Reproduzierbarkeit und Qualität von Information-Retrieval-Ergebnissen haben @Roy2018_Cleaning[S. 3].
Implikationen für RAG-Systeme
Die Qualität der Dokumentenvorbereitung wirkt sich direkt auf nachgelagerte Prozesse aus. Fehlerhafte Textextraktion, etwa durch OCR-Fehler oder Layout-Artefakte, propagiert sich in die Chunking-Phase und beeinträchtigt sowohl die Embedding-Qualität als auch die Retrieval-Präzision. Zhang et al. betonen, dass Document Parsing "eine unverzichtbare Rolle sowohl beim Aufbau von Wissensdatenbanken als auch bei der Generierung von Trainingsdaten" spielt, insbesondere im Kontext von RAG-Systemen @Zhang2024_DocParsing[S. 1]. Eine robuste Dokumentenvorbereitung muss daher nicht nur Text extrahieren, sondern auch strukturelle Informationen wie Überschriftenhierarchien und Absatzgrenzen erhalten, die für kontextuelle Chunking-Strategien relevant sind.
== Chunking als zentrale Preprocessing-Komponente
Während die Dokumentenvorbereitung Rohdokumente in strukturierten Text überführt, adressiert Chunking die zentrale Herausforderung, dass LLMs aufgrund begrenzter Kontextfenster nicht mit vollständigen Dokumenten operieren können. Chunking bezeichnet die Segmentierung großer Textdokumente in kleinere, semantisch kohärente Einheiten, die als Retrieval-Einheiten in RAG-Systemen dienen.
Notwendigkeit des Chunkings
Die Notwendigkeit des Chunkings ergibt sich aus mehreren technischen Limitationen:
Kontextfenster-Restriktion: Wie in Abschnitt 2.3 dargestellt, sind LLMs durch die maximale Anzahl verarbeitbarer Token begrenzt. Selbst wenn moderne Modelle Kontextfenster von mehreren tausend Token unterstützen, kann die Verarbeitung vollständiger Dokumente – etwa wissenschaftlicher Paper oder Bücher – diese Kapazität überschreiten. RAG-Systeme umgehen diese Limitation, indem sie nur relevante Textfragmente als Kontext bereitstellen.
Retrieval-Granularität: Die Wahl der Chunk-Größe beeinflusst fundamental die Retrieval-Qualität. Oche et al. identifizieren ein Trade-off zwischen Vollständigkeit und Spezifität: "Chunks müssen groß genug sein, um nützlichen Kontext zu enthalten, aber klein genug, um Queries präzise zu matchen und in Modell-Kontextfenster zu passen" @oche2025systematic[S. 5]. Die Verwendung feinkörniger Textchunks als Retrieval-Einheiten erhöht die Wahrscheinlichkeit, dass eine Query ein hochrelevantes Fragment identifiziert, anstatt ein vollständiges, potentiell weitschweifiges Dokument zu retrieven @karpukhin2020dpr[S. 2].
Embedding-Qualität: Semantisch kohärente Chunks ermöglichen präzisere Vektorrepräsentationen. Dense Retrieval-Verfahren wie Dense Passage Retrieval (DPR) @karpukhin2020dpr nutzen Bi-Encoder-Architekturen, die Text in hochdimensionale Vektorräume einbetten. Wenn Chunks thematisch kohärente Einheiten darstellen, reflektiert ihre Embedding-Repräsentation die semantische Bedeutung präziser, was zu besseren Similarity-Scores bei der Query-Matching führt.
Anforderungen an effektive Chunks
Nguyen et al. argumentieren, dass "traditionelle Methoden oft daran scheitern, Chunks zu erstellen, die ausreichende semantische Bedeutung erfassen, da sie die zugrundeliegende Textstruktur nicht berücksichtigen" @Nguyen2025_Chunking[S. 1]. Daraus lassen sich grundlegende Anforderungen an effektive Chunking-Strategien ableiten:
Semantische Kohärenz: Chunks sollten thematisch abgeschlossene Einheiten bilden und nicht willkürlich inmitten semantischer Zusammenhänge enden. Fixed-size Chunking – die einfachste Form der Segmentierung, bei der Text nach einer festen Anzahl von Zeichen oder Token aufgeteilt wird – ignoriert semantische Grenzen und führt häufig zu fragmentierten Kontexten. Oche et al. stellen fest: "Fixed-size Chunks, wie sie im frühen RAG verwendet wurden, sind anfällig für semantische Fragmentierung" @oche2025systematic[S. 19].
Kontextuelle Vollständigkeit: Jeder Chunk muss ausreichend Kontext enthalten, um als eigenständige Informationseinheit für das Retrieval und die Generierung zu fungieren. Dies impliziert, dass Chunks nicht nur syntaktisch vollständig sein sollten (keine abgeschnittenen Sätze), sondern auch genügend Hintergrundinformation bereitstellen, um ohne den umgebenden Dokumentenkontext interpretierbar zu sein.
Technische Constraints: Praktische Limitationen ergeben sich aus Embedding-Modellen, die häufig eine maximale Token-Länge definieren (z.B. 512 Token bei BERT-basierten Modellen), sowie aus Effizienzerwägungen bezüglich Index-Größe und Retrieval-Latenz. Die Balance zwischen granularer Segmentierung (viele kleine Chunks für präzises Matching) und Kontexterhalt (größere Chunks für vollständige Information) muss task-spezifisch optimiert werden.



= Chunking-Strategien in RAG-Systemen

Die Aufteilung von Dokumenten in kleinere, handhabbare Einheiten – das sogenannte Chunking – stellt eine zentrale Komponente in RAG-Systemen dar, deren Qualität maßgeblich die Performance des gesamten Systems beeinflusst. Während im vorherigen Kapitel die grundlegende Notwendigkeit von Chunking als Preprocessing-Schritt erläutert wurde, widmet sich dieses Kapitel der detaillierten Analyse verschiedener Chunking-Strategien sowie deren spezifischen Eigenschaften, Vor- und Nachteilen.

== Grundprinzipien und Trade-offs im Chunking

Die Segmentierung von Dokumenten in Chunks unterliegt fundamentalen Zielkonflikten, die bei der Auswahl einer geeigneten Strategie berücksichtigt werden müssen. Im Kern geht es darum, die begrenzte Kontextfenstergröße von LLMs effizient zu nutzen, ohne dabei semantisch kohärente Informationseinheiten zu fragmentieren.

=== Notwendigkeit und Qualitätskriterien

RAG-Systeme sind darauf angewiesen, relevante Kontextinformationen aus großen Dokumentenkorpora zu extrahieren und diese dem LLM zur Verfügung zu stellen @lewis2020retrieval. Da LLMs typischerweise über Kontextfenster von 4.096 bis 32.768 Tokens verfügen, ist die direkte Verarbeitung vollständiger Dokumente – insbesondere bei umfangreichen technischen Berichten oder wissenschaftlichen Artikeln – nicht praktikabel. Chunking ermöglicht eine granulare Retrieval-Strategie, bei der nur die für eine Query relevanten Dokumentfragmente dem LLM präsentiert werden.

Effektives Chunking muss drei zentrale Qualitätskriterien erfüllen. Erstens erfordert semantische Kohärenz, dass Chunks inhaltlich zusammenhängende Informationseinheiten bilden, ohne Kontextbrüche an Chunk-Grenzen zu erzeugen @Nguyen2025_Chunking. Zweitens muss Kontexterhalt gewährleistet sein, sodass die in einem Chunk enthaltene Information auch ohne den umgebenden Dokumentkontext verständlich bleibt. Drittens spielt die Retrieval-Effizienz eine wesentliche Rolle, da sowohl die Größe der Embedding-Datenbank als auch die Rechenkosten für die Vektorsuche direkt von der Anzahl der Chunks abhängen.

=== Trade-offs in der Chunk-Größenwahl

Die Wahl der Chunk-Größe unterliegt einem fundamentalen Zielkonflikt zwischen Retrieval-Präzision und Kontextqualität. Kleinere Chunks ermöglichen eine präzisere semantische Suche, da die Embedding-Vektoren spezifischere Informationen repräsentieren @oche2025systematic. Dies erhöht die Wahrscheinlichkeit, dass der Retrieval-Mechanismus exakt die zur Query passende Information identifiziert. Gleichzeitig steigt jedoch das Risiko der semantischen Fragmentierung, bei der zusammenhängende Gedankengänge über mehrere Chunks verteilt werden.

Größere Chunks bewahren zwar mehr Kontext und reduzieren die Gesamtzahl der zu indexierenden Einheiten, führen jedoch zu einer Verdünnung der semantischen Spezifität in den Embedding-Repräsentationen. Empirische Untersuchungen zeigen, dass die optimale Chunk-Größe task-spezifisch ist: Während für faktische Question-Answering-Aufgaben kleinere Chunks (256-512 Tokens) bevorzugt werden, erzielen narrative Aufgaben bessere Ergebnisse mit größeren Einheiten (1.024-2.048 Tokens) @Nguyen2025_Chunking.

Ein weiterer Trade-off besteht zwischen der Uniformität der Chunk-Größen und der Wahrung natürlicher Dokumentstrukturen. Fixed-size Chunking garantiert konstante Chunk-Größen, ignoriert jedoch semantische Grenzen wie Absatzenden oder Abschnittswechsel. Strukturbasierte Ansätze respektieren diese natürlichen Einheiten, erzeugen jedoch variable Chunk-Größen, was die nachgelagerte Verarbeitung und Evaluation erschweren kann.

== Taxonomie etablierter Chunking-Verfahren

Die Landschaft der Chunking-Strategien lässt sich in drei Hauptkategorien unterteilen, die unterschiedliche Kompromisse zwischen Implementierungskomplexität, Flexibilität und semantischer Qualität eingehen.

=== Fixed-Size Chunking

Fixed-size Chunking bezeichnet Verfahren, die Dokumente in Einheiten fester Länge unterteilen, wobei die Länge entweder in Zeichen oder Tokens gemessen wird. Diese Ansätze zeichnen sich durch ihre Einfachheit und Reproduzierbarkeit aus, da keine komplexe Analyse der Dokumentstruktur oder -semantik erforderlich ist @oche2025systematic.

Character-based Fixed-Size Chunking segmentiert Texte nach einer festgelegten Zeichenanzahl. Der Hauptvorteil liegt in der Sprach- und Modellunabhängigkeit sowie der gleichmäßigen Auslastung der Speicher- und Rechenressourcen. Die zentrale Schwäche besteht jedoch darin, dass Chunk-Grenzen arbiträr innerhalb von Wörtern oder Sätzen verlaufen können, was zu semantischer Fragmentierung führt.

Token-based Fixed-Size Chunking adressiert dieses Problem teilweise, indem es auf Token-Ebene operiert. Tokens, die durch Subword-Tokenization-Verfahren wie Byte Pair Encoding (BPE) erzeugt werden, respektieren zumindest Subword-Grenzen @Sennrich2016_BPE. Dies ist besonders relevant für LLM-basierte Systeme, da die Chunk-Größe direkt mit den Token-Limits der verwendeten Modelle abgestimmt werden kann. Dennoch bleibt die grundsätzliche Problematik bestehen, dass semantische Einheiten wie Sätze oder Absätze durchschnitten werden.

=== Semantic Chunking

Semantic Chunking bezeichnet Verfahren, die Chunk-Grenzen basierend auf semantischer Ähnlichkeit oder thematischer Kohärenz bestimmen. Diese Ansätze nutzen typischerweise Embedding-Modelle, um die semantische Distanz zwischen aufeinanderfolgenden Texteinheiten (meist Sätzen) zu messen und Chunks bei signifikanten Kohärenzbrüchen zu erzeugen @Nguyen2025_Chunking.

Der Vorteil semantischer Verfahren liegt in der hohen inhaltlichen Kohärenz der resultierenden Chunks, da thematisch zusammengehörige Informationen gruppiert werden. Die Herausforderung besteht jedoch in der variablen Chunk-Größe, die von wenigen Sätzen bis zu mehreren Absätzen reichen kann. Dies erschwert die Kontrolle über die Anzahl der zu indexierenden Chunks und kann zu extrem kleinen oder großen Einheiten führen, die jeweils suboptimal für das Retrieval sind.

Zudem erfordert Semantic Chunking rechenintensive Embedding-Berechnungen für jede Satzgrenze und die Definition eines Schwellenwerts für semantische Kohärenz, der domänen- und korpusspezifisch angepasst werden muss.

=== Structure-Aware Chunking

Structure-aware Chunking nutzt die inhärente Struktur von Dokumenten – wie Überschriften, Absätze oder Kapitelgrenzen – als natürliche Chunk-Grenzen. Diese Ansätze basieren auf der Annahme, dass Autoren Dokumente bereits in semantisch kohärente Einheiten gliedern, die sich als Chunks eignen @Nguyen2025_Chunking.

Hierarchical Segmentation-Verfahren verwenden überwachte Machine-Learning-Modelle, um semantische Segmentgrenzen in Texten zu identifizieren. Nguyen et al. demonstrieren einen Ansatz, der auf bidirektionalen LSTM-Netzwerken basiert und trainiert wird, Satzgrenzen als potenzielle Segmentgrenzen zu klassifizieren @Nguyen2025_Chunking. Diese Segmente werden anschließend durch Clustering zu größeren Chunks aggregiert, wobei sowohl semantische Ähnlichkeit als auch die sequenzielle Anordnung berücksichtigt werden.

Document-Structure-Based Chunking stellt eine pragmatische Variante dar, die explizite Strukturelemente wie Markdown-Überschriften, HTML-Tags oder LaTeX-Sections als Chunk-Grenzen verwendet. Dies erfordert keine Trainingsphase und kann mittels regelbasierter Parser implementiert werden. Die Qualität hängt jedoch stark von der Strukturiertheit der Quelldokumente ab – während technische Dokumentationen und wissenschaftliche Artikel typischerweise gut strukturiert sind, fehlt diese Eigenschaft bei vielen Web-Texten oder informellen Dokumenten.

== Detailbeschreibung der evaluierten Strategien

Für die empirische Evaluation in dieser Arbeit wurden drei repräsentative Chunking-Strategien ausgewählt, die unterschiedliche Ansätze der vorgestellten Taxonomie abbilden und verschiedene Trade-offs konkretisieren.

=== Simple Character-Based Chunking mit Overlap

Simple Character-Based Chunking implementiert den grundlegendsten Ansatz des Fixed-Size Chunking, indem Dokumente nach einer festgelegten Zeichenanzahl segmentiert werden.

*Funktionsweise:* Der Text wird sequenziell durchlaufen und bei Erreichen der Chunk-Größe $n$ (gemessen in Unicode-Zeichen) eine Grenze gezogen. Um Kontextverluste an Chunk-Grenzen zu minimieren, wird ein Overlap der Länge $o$ implementiert, sodass die letzten $o$ Zeichen eines Chunks auch am Anfang des nächsten Chunks erscheinen.

*Hyperparameter:* Die Strategie wird durch zwei Parameter gesteuert:
- `chunk_size`: Anzahl der Zeichen pro Chunk (typisch: 500-2.000)
- `overlap_size`: Anzahl überlappender Zeichen (typisch: 10-20% der chunk_size)

*Stärken:* Die Implementierung ist trivial und erfordert keine externen Abhängigkeiten oder Modelle. Die Reproduzierbarkeit ist maximal, da keine stochastischen Komponenten involviert sind. Zudem garantiert die Strategie konstante Chunk-Größen, was die Speicherverwaltung und Batch-Verarbeitung vereinfacht. Die Sprachunabhängigkeit macht den Ansatz universell einsetzbar.

*Schwächen:* Die zentrale Schwäche liegt in der vollständigen Ignoranz gegenüber linguistischen und semantischen Strukturen. Chunk-Grenzen können mitten in Wörtern, Sätzen oder Gedankengängen verlaufen, was zu schwer interpretierbaren Fragmenten führt. Bei morphologisch komplexen Sprachen (z.B. Deutsch mit Komposita) ist die Fragmentierung besonders problematisch. Zudem führt die zeichenbasierte Messung zu inkonsistenten Token-Counts pro Chunk, da die Zeichen-zu-Token-Ratio sprachspezifisch variiert.

*Erwartete Performance:* Als Baseline-Strategie dient Simple Character-Based Chunking primär der Kontextualisierung komplexerer Verfahren. Die Hypothese lautet, dass diese Strategie bei faktischen Question-Answering-Tasks unterdurchschnittlich abschneidet, da relevante Informationen häufig fragmentiert werden und Kontextinformationen verloren gehen.

=== Token-Based Chunking mit Tiktoken

Token-Based Chunking adressiert eine zentrale Schwäche zeichenbasierter Verfahren, indem es auf der Token-Ebene operiert und damit die Segmentierungslogik des verwendeten LLMs respektiert.

*Funktionsweise:* Statt Zeichen zu zählen, wird der Text zunächst mittels eines Tokenizers in Subword-Units zerlegt. In dieser Arbeit wird OpenAI's Tiktoken-Tokenizer verwendet, der auf Byte Pair Encoding (BPE) basiert @Sennrich2016_BPE. BPE ist ein datengetriebenes Kompressionsverfahren, das iterativ die häufigsten Byte-Paare in einem Korpus zu neuen Subword-Einheiten verschmilzt. Dies führt zu einem Vokabular variabler Länge, bei dem häufige Wörter als einzelne Tokens repräsentiert werden, während seltene Wörter in mehrere Subword-Tokens zerfallen.

Der Tiktoken-Tokenizer nutzt ein vordefiniertes Vokabular von etwa 100.000 Subword-Units, das auf einem großen Korpus trainiert wurde. Nach der Tokenisierung werden Chunks nach einer festgelegten Token-Anzahl $n_t$ gebildet, wobei ein Overlap von $o_t$ Tokens implementiert wird. Die resultierenden Token-Sequenzen werden für die Speicherung in der Vektordatenbank wieder in Text dekodiert.

*Hyperparameter:*
- `token_count`: Anzahl der Tokens pro Chunk (typisch: 256-1.024)
- `overlap_tokens`: Anzahl überlappender Tokens (typisch: 10-20% der token_count)

*Stärken:* Der zentrale Vorteil liegt in der direkten Alignierung mit den Token-Limits der verwendeten LLMs. OpenAI-Modelle operieren mit strikten Token-Budgets (z.B. 4.096 Tokens für GPT-3.5), sodass token-basiertes Chunking eine präzise Kontrolle über die Kontextfenstergröße ermöglicht. Zudem respektiert BPE Morphemgrenzen besser als zeichenbasierte Verfahren, da häufige Morpheme als eigenständige Tokens gelernt werden @Sennrich2016_BPE. Dies reduziert die Fragmentierung semantischer Einheiten.

Im Vergleich zu character-based Chunking führt die token-basierte Messung zu konsistenteren Chunk-Größen bezüglich der LLM-Verarbeitung, da die Varianz in der Zeichen-zu-Token-Ratio eliminiert wird. Die Methode bleibt dabei weitgehend sprachunabhängig, sofern der Tokenizer multilingual trainiert wurde.

*Schwächen:* Token-based Chunking bleibt semantisch blind – Chunk-Grenzen folgen nach wie vor einer fixen Zählung ohne Berücksichtigung syntaktischer oder semantischer Strukturen. Ein Satz kann zwischen zwei Chunks aufgeteilt werden, wenn die Token-Grenze erreicht wird. Zudem ist die Methode abhängig vom gewählten Tokenizer; unterschiedliche BPE-Vokabulare führen zu unterschiedlichen Segmentierungen @Sennrich2016_BPE. Die Verwendung eines proprietären Tokenizers (wie Tiktoken) schränkt die Reproduzierbarkeit ein, da Implementierungsdetails und Trainingsdaten nicht vollständig dokumentiert sind.

*Erwartete Performance:* Die Hypothese lautet, dass Token-based Chunking gegenüber Character-based Chunking leichte Verbesserungen erzielt, insbesondere bei Retrieval-Aufgaben, die präzise Kontextkontrolle erfordern. Die Reduktion der Token-Fragmentierung sollte zu kohärenteren Chunks führen. Dennoch wird erwartet, dass die Performance hinter strukturbasierten Ansätzen zurückbleibt, da semantische Grenzen weiterhin ignoriert werden.

=== Strukturbasiertes Chunking anhand natürlicher Dokumentgrenzen

Das strukturbasierte Chunking nutzt die inhärente Organisation von Dokumenten, um semantisch kohärente Chunks zu erzeugen. Im Gegensatz zu ML-basierten Segmentierungsverfahren, die umfangreiche Trainingsdaten erfordern @Nguyen2025_Chunking, basiert dieser Ansatz auf regelbasierten Parsern, die explizite Strukturmarkierungen extrahieren.

*Funktionsweise:* Dokumente werden mittels struktureller Marker (z.B. Markdown-Überschriften wie `\#`, `\#\#`, HTML-Tags wie `<h1>`, `<h2>`, oder LaTeX-Sections) in hierarchische Einheiten zerlegt. Jede durch diese Marker definierte Sektion wird als eigenständiger Chunk behandelt. Bei Dokumenten ohne explizite Markup-Struktur können alternative Heuristiken eingesetzt werden, z.B. die Identifikation von Absatzgrenzen durch doppelte Zeilenumbrüche.

Um extreme Chunk-Größen zu vermeiden, werden zwei zusätzliche Hyperparameter eingeführt:
- Sehr kurze Sektionen (< `min_chunk_size` Tokens) werden mit der nachfolgenden Sektion verschmolzen
- Sehr lange Sektionen (> `max_chunk_size` Tokens) werden mittels eines Fallback-Mechanismus (z.B. token-based chunking) weiter unterteilt

*Hyperparameter:*
- `min_chunk_size`: Minimale Token-Anzahl pro Chunk (typisch: 100)
- `max_chunk_size`: Maximale Token-Anzahl pro Chunk (typisch: 1.500)
- `structure_level`: Hierarchieebene der zu verwendenden Strukturelemente (z.B. nur H1-H2 vs. alle Überschriften)

*Stärken:* Der zentrale Vorteil liegt in der hohen semantischen Kohärenz der resultierenden Chunks. Kapitel, Abschnitte oder thematische Einheiten bleiben intakt, da Autoren typischerweise Strukturmarkierungen an semantischen Bruchstellen setzen. Dies führt zu kontextuell vollständigen Chunks, die auch ohne umgebende Information verständlich sind.

Empirische Studien zeigen, dass die Bewahrung der Dokumentstruktur insbesondere bei komplexen, informationsdichten Texten (z.B. technischen Spezifikationen, wissenschaftlichen Artikeln) zu besseren Retrieval-Ergebnissen führt, da zusammengehörige Konzepte gemeinsam indexiert werden @Nguyen2025_Chunking. Die Implementierung erfordert zudem kein Training und kann durch einfache Parser realisiert werden.

*Schwächen:* Die Qualität des strukturbasierten Chunking hängt kritisch von der Strukturiertheit der Quelldokumente ab. Während formelle Dokumente (technische Berichte, Lehrbücher) typischerweise gut gegliedert sind, fehlt diese Eigenschaft bei vielen Web-Texten, Blog-Posts oder informellen Notizen. In solchen Fällen muss auf Fallback-Strategien zurückgegriffen werden.

Die variable Chunk-Größe stellt eine weitere Herausforderung dar. Während manche Abschnitte nur wenige Sätze umfassen, können andere mehrere Seiten Text enthalten. Diese Heterogenität erschwert die Evaluation, da Chunk-Größeneffekte nicht isoliert betrachtet werden können. Zudem kann die Indexierung sehr großer Chunks zu Retrieval-Verzerrungen führen, wenn das Embedding-Modell semantische Nuancen in umfangreichen Texten nicht adäquat erfasst.

*Erwartete Performance:* Die Hypothese lautet, dass strukturbasiertes Chunking bei komplexen Informationsbedürfnissen überlegen ist, die ein tiefes Verständnis thematischer Zusammenhänge erfordern. Insbesondere bei Multi-Hop-Reasoning-Aufgaben, bei denen Informationen aus mehreren Textabschnitten kombiniert werden müssen, sollte die Bewahrung semantischer Einheiten vorteilhaft sein. Bei einfachen faktischen Queries könnte jedoch die variable Chunk-Größe nachteilig wirken, wenn große Chunks mehrere nur teilweise relevante Themen enthalten.

== Overlap-Strategien zur Kontexterhaltung

Overlap bezeichnet die Technik, aufeinanderfolgende Chunks partiell überlappen zu lassen, sodass die letzten $k$ Einheiten (Zeichen oder Tokens) eines Chunks auch am Anfang des nachfolgenden Chunks erscheinen. Diese Strategie adressiert ein fundamentales Problem aller Fixed-Size und strukturbasierten Chunking-Verfahren: Informationen, die an Chunk-Grenzen liegen, können im Retrieval-Prozess verloren gehen.

=== Motivation und Mechanismus

Ohne Overlap kann eine Anfrage, die Informationen aus dem Ende von Chunk $i$ und dem Anfang von Chunk $i+1$ benötigt, suboptimal bedient werden, da keiner der beiden Chunks den vollständigen Kontext enthält. Overlap schafft redundante Kontextzonen, die sicherstellen, dass Informationen an Chunk-Grenzen in mindestens einem der beteiligten Chunks vollständig repräsentiert sind.

Der Mechanismus ist einfach: Bei der Erzeugung von Chunk $i+1$ beginnt die Segmentierung nicht unmittelbar nach dem Ende von Chunk $i$, sondern $o$ Einheiten früher. Dies führt zu einer Redundanz von $(o / s) times 100$%, wobei $s$ die durchschnittliche Chunk-Größe bezeichnet.

=== Empirische Erkenntnisse

Nguyen et al. demonstrieren in ihren Experimenten auf den Datensätzen NarrativeQA, QASPER und QuALITY, dass Overlap die Retrieval-Performance konsistent verbessert @Nguyen2025_Chunking. In ihren Versuchen wurden verschiedene Chunk-Größen (256, 512, 1.024, 2.048 Tokens) sowohl mit als auch ohne Overlap evaluiert. Die Ergebnisse zeigen, dass insbesondere bei mittleren Chunk-Größen (512-1.024 Tokens) die Verwendung von Overlap zu signifikanten Verbesserungen im ROUGE-L und F1-Score führt.

Die Autoren argumentieren, dass Overlap besonders bei narrativen Texten und technischen Dokumenten vorteilhaft ist, bei denen kohärente Gedankengänge über mehrere Sätze hinweg entwickelt werden. Bei fragmentierten Texten (z.B. Listen, Stichpunkte) ist der Effekt hingegen geringer, da semantische Einheiten bereits durch die Dokumentstruktur separiert sind.

=== Trade-offs und Hyperparameter-Wahl

Die Wahl der Overlap-Größe unterliegt einem Trade-off zwischen Kontexterhalt und Ressourceneffizienz. Größere Overlaps erhöhen die Redundanz und damit die Speicher- sowie Rechenkosten für Embedding-Generierung und Vektorsuche. Empirische Untersuchungen deuten darauf hin, dass Overlap-Raten zwischen 10% und 20% der Chunk-Größe einen guten Kompromiss darstellen @Nguyen2025_Chunking.

Bei sehr kleinen Chunks (< 256 Tokens) kann ein relativ großer Overlap notwendig sein, um Kontextverluste zu vermeiden, was jedoch die Gesamtanzahl der Chunks signifikant erhöht. Bei sehr großen Chunks (> 2.048 Tokens) ist der Nutzen von Overlap geringer, da einzelne Chunks bereits umfangreichen Kontext enthalten.

In dieser Arbeit wird für alle evaluierten Strategien eine konsistente Overlap-Rate von 15% der Chunk-Größe verwendet, um eine faire Vergleichbarkeit zu gewährleisten und gleichzeitig die Speichereffizienz zu bewahren.


= Evaluation