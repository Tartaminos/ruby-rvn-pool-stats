# CoinMonitor

CoinMonitor é uma aplicação Ruby que monitora o hashrate e a dificuldade de mineração de uma rede blockchain (Ravencoin) e envia alertas via WhatsApp usando a API do WhatsApp Business.

## Configuração

### 1. Clone o Repositório

´´´ bash
git clone https://github.com/seu-usuario/coin_monitor.git
cd coin_monitor´´´

### 2. Instale as Dependências
``` bundle install ´´´

### 3. Configure as Variáveis de Ambiente
Crie um arquivo .env na raiz do projeto e adicione as seguintes variáveis:

´´´ MY_PHONE_NUMBER=YOUR_PHONE_NUMBER
ACCESS_TOKEN=YOUR_ACCESS_TOKEN
PHONE_NUMBER_ID=YOUR_PHONE_NUMBER_ID
YOUR_PHONE_NUMBER=YOUR_PHONE_NUMBER ´´´

Substitua YOUR_PHONE_NUMBER, YOUR_ACCESS_TOKEN, YOUR_PHONE_NUMBER_ID, YOUR_TWILIO_ACCOUNT_SID, YOUR_TWILIO_AUTH_TOKEN, whatsapp:+14155238886 e whatsapp:+5519982828418 pelos valores apropriados.

### Execução

Execute o script coin_monitor.rb para iniciar o monitoramento:

´´´ ruby coin_monitor.rb ´´´
