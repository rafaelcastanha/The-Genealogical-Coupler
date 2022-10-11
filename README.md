# The-Coupler-Academic-Genealogy-version
Bibliographic coupling in academic genealogy context (between advisor and advisee)

Calcula a intensidade de acoplamento bibliográfico entre orientador e orientandos juntamente com as matrizes de citação, cocitação e acoplamento entre todos atores analisados. 

1) A ferramenta pode ser usada para qualquer tipo de unidade (documentos, autores, periódicos, palavras-chave, DOI, seguidores em redes sociais, etc).

2) Selecione o arquivo em extensão txt para executar o processamento: O arquivo deve ser organizado em colunas separadas por vírgula, ponto e vírgula ou tabulado, em que o cabeçalho representa o item citante e cada linha abaixo do cabeçalho, os itens citados. A lista de referencia citada do orientador deve constar na primeira coluna do corpus (utilize "arquivos para teste" para exemplos de organização do arquivo)

3) É desejavel que cada coluna contenha valores únicos.

3) Selecione a separação do seu arquivo: vírgula, ponto e vírgula ou tabulado.

4) Clique em "Coupling!".

5) X1 e X2 representam os itens comparados (ex: Autor 1 e Autor 2 a serem acoplados).

6) refs_X1 e refs_x2 representam o tamanho (cardinalidade) da lista referências (itens citados) pelos itens citantes X1 e X2.

7) "Coupling" representa o número de itens citados em comum por X1 e X2 (em alusão a Acoplamento Bibliográfico).

8) Jaccard_Index, Saltons_Cosine e CAG representam as normalizações via Índice de Jaccard, Cosseno de Salton e CAG*.

9) "Unidades de Acoplamento" identifica quais foram a unidades responsáveis por promover a intersecção entre X1 e X2.

10) A "Matriz de Citação" não é ponderada e apresenta a matriz booleana de citação composta por 0 ou 1.

11) A "Matriz de Acoplamento" é ponderada pelos valores de acoplamento presentes em "Coupling".

12) Os valores de entrada da "Matriz de Cocitação" representam a quantidade de listas de referências em que cada par é cocitado.

13) Caso nenhuma das unidades de análise se acoplem entre si, será retornada uma mensagem de alerta.

14) Esta aplicação é derivada de The Coupler: https://rafaelcastanha.shinyapps.io/thecoupler

15) contato: rafael.castanha@unesp.br

*CAG=(ABA)/(Cardinalidade da lista do orientador).

*A métrica CAG foi desenvolvida por Castanha (2021) em: Coeficiente de acoplamento bibliográfico genealógico para mensurar a intensidade da preservação das correntes teórico-metodológicas nas redes de genealogia acadêmica da área de Matemática (Tese de doutorado em Ciência da Informação - UNESP campus Marília/SP). Consulte "Sobre a métrica CAG"
