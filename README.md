# The Genealogical Coupler

![alt text](https://raw.githubusercontent.com/rafaelcastanha/The-Genealogic-Coupler/main/gacoupler_git.bmp)

Bibliographic coupling in academic genealogy context (between advisor and advisee)

Calcula a intensidade de acoplamento bibliográfico entre orientador e orientandos juntamente com as matrizes de citação, cocitação e acoplamento entre todos atores analisados. 

1) A ferramenta pode ser usada para qualquer tipo de unidade (documentos, autores, periódicos, palavras-chave, DOI, seguidores em redes sociais, etc).

2) Selecione o arquivo em extensão txt para executar o processamento: O arquivo deve ser organizado em colunas separadas por vírgula, ponto e vírgula ou tabulado, em que o cabeçalho representa o item citante e cada linha abaixo do cabeçalho, os itens citados. A lista de referência citada do orientador deve constar na primeira coluna do corpus (utilize "arquivos para teste" para exemplos de organização do arquivo).

3) É desejavel que cada coluna contenha valores únicos.

4) Carregue seu arquivo e selecione a separação do seu arquivo: vírgula, ponto e vírgula ou tabulado.

5) Clique em "Coupling!".

6) "Orientador" e "Orientandos" representam os itens acoplados.

7) L1 e L2 representam o tamanho (cardinalidade) da lista referências (itens citados) pelos itens citantes: Orientador e Orientandos.

8) "Coupling" representa o número de itens citados em comum entre L1 e L2 (em alusão a Acoplamento Bibliográfico).

9) Jaccard_Index, Saltons_Cosine e CAG representam as normalizações via Índice de Jaccard, Cosseno de Salton e CAG*.

10) "Unidades de Acoplamento" identifica quais foram a unidades responsáveis por promover a intersecção entre L1 e L2.

11) A "Matriz de Citação" não é ponderada e apresenta a matriz booleana de citação composta por 0 ou 1.

12) A "Matriz de Acoplamento" é ponderada pelos valores de acoplamento presentes em "Coupling".

13) Os valores de entrada da "Matriz de Cocitação" representam a quantidade de listas de referências em que cada par é cocitado.

14) Caso nenhuma das unidades de análise se acoplem entre si, será retornada uma mensagem de alerta.

15) Web-App em funcionamento em: https://rafaelcastanha.shinyapps.io/thegenealogiccoupler

16) Esta aplicação é derivada de The Coupler: https://rafaelcastanha.shinyapps.io/thecoupler

17) contato: rafael.castanha@unesp.br

*CAG=(Coupling)/L1

*A métrica CAG foi desenvolvida por Castanha (2021) em: Coeficiente de acoplamento bibliográfico genealógico para mensurar a intensidade da preservação das correntes teórico-metodológicas nas redes de genealogia acadêmica da área de Matemática (Tese de doutorado em Ciência da Informação - UNESP campus Marília/SP). 

*Consulte "Sobre a métrica CAG"
