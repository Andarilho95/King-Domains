King-Domains

Pipeline automatizado de enumeração de subdomínios para recon, bug bounty e pentest.

king-domains integra amass, subfinder e assetfinder em um único fluxo para coletar, consolidar, filtrar por escopo e validar subdomínios ativos.

Ambiente

Desenvolvido e testado em:

Arch Linux

BlackArch

Ferramentas necessárias

amass

subfinder

assetfinder

As ferramentas podem ser instaladas via BlackArch ou manualmente a partir dos repositórios oficiais de cada projeto.

Uso
./king-domains raw-domains.txt final-domains.txt

Formato do escopo

O arquivo raw-domains.txt deve conter wildcards apenas no formato abaixo, um por linha:

*.example.org

*.corp.internal


Somente este padrão é suportado.

Como o script funciona

O king-domains opera em duas entradas e um pipeline determinístico.

O comando recebe:

./king-domains raw-domains.txt final-domains.txt


Onde:

raw-domains.txt contém os domínios em wildcard

final-domains.txt é o arquivo onde os subdomínios válidos e ativos serão gravados

Fluxo de execução

Leitura do escopo

O script lê o primeiro arquivo (raw-domains.txt), que contém todos os domínios em wildcard que definem o escopo da operação.

Enumeração por ferramenta
Para cada domínio em wildcard, o script executa, em sequência:

amass enum -passive

subfinder

assetfinder

Todas as ferramentas são executadas para cada wildcard individualmente.

Consolidação dos resultados
Os subdomínios retornados por todas as ferramentas são agregados em um único conjunto, eliminando linhas vazias e normalizando a saída.

Filtragem por escopo
Como as ferramentas frequentemente retornam domínios fora do escopo solicitado, o script remove todos os subdomínios que não correspondem aos wildcards informados no arquivo de entrada.
Apenas subdomínios que pertencem ao escopo original são mantidos.

Remoção de duplicados
Subdomínios repetidos entre ferramentas são eliminados, garantindo uma lista única de alvos.

Validação de host ativo
Cada subdomínio final é testado individualmente com ping.
Apenas os hosts que respondem são considerados ativos.

Geração do output final
Todos os subdomínios ativos e dentro de escopo são gravados no arquivo de saída (final-domains.txt).

Resultado

O resultado final é uma lista limpa de subdomínios válidos, dentro de escopo e ativos, pronta para uso em recon, bug bounty ou pentest.
