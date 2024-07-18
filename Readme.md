# CoinMonitor

CoinMonitor é uma aplicação Ruby que monitora o hashrate e a dificuldade de mineração de uma rede blockchain Ravencoin, envia alertas via Telegram.

## Configuração

### 1. Clone o Repositório
```
bash
git clone https://github.com/seu-usuario/coin_monitor.git
cd coin_monitor
```

### 2. Instale as Dependências
``` bundle install ```

### 3. Crie um bot do telegram

Você deve possuir um bot do telegram, crie um através do botfather e inicie um conversa.
Usando o token informado pelo botfather acesse o seguinte link: ``` https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates ```
No JSON localize a chave ``` {chat: {id: 123}} ```  e use-a na variavel de ambiente.

### 4. Configure as Variáveis de Ambiente
Crie um arquivo .env na raiz do projeto e adicione as seguintes variáveis:

```
TELEGRAM_BOT_TOKEN="<TELEGRAM_BOT_TOKEN>"
TELEGRAM_CHAT_ID=<TELEGRAM_CHAT_ID> 
```

Substitua TELEGRAM_BOT_TOKEN e TELEGRAM_CHAT_ID pelos valores apropriados.

## Execução

Execute o script coin_monitor.rb para iniciar o monitoramento:

``` ruby coin_monitor.rb ```
