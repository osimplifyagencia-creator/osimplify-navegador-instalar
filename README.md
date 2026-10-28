# Navegador Osimplify: instalação

A extensão de Chrome da Osimplify que deixa o Claude usar o seu navegador, já logado nas suas contas, numa janela separada. Este repositório traz a extensão pronta, sem precisar compilar nada.

> Atalho: abra o Claude Code nesta pasta e peça "lê o PARA-O-CLAUDE.md e instala o Navegador Osimplify pra mim". O [PARA-O-CLAUDE.md](PARA-O-CLAUDE.md) é o guia escrito para o Claude: ele instala, te chama só no passo do Chrome e depois sabe usar.

## O que você precisa antes

- Windows 10 ou 11.
- Google Chrome.
- Claude Code instalado e aberto pelo menos uma vez.
- Git, para clonar e para atualizar depois.

## Instalar (uns 5 minutos)

1. Clone o repositório numa pasta que você não vai apagar. O Chrome carrega a extensão direto dessa pasta.

   ```powershell
   git clone https://github.com/osimplifyagencia-creator/osimplify-navegador-instalar.git C:\osimplify-navegador
   ```

2. Abra a pasta e dê dois cliques em `INSTALAR.bat`. Ele instala a ferramenta `bsk`, instala a skill no Claude Code e abre o Chrome na tela de extensões.

3. No Chrome que abriu (`chrome://extensions`):
   - ligue o **Modo do desenvolvedor**, no canto de cima à direita;
   - clique em **Carregar sem compactação**;
   - cole o caminho da pasta `extensao` (o instalador já deixou copiado, é só Ctrl+V) e confirme.

4. Clique no ícone do Navegador Osimplify na barra do Chrome. Se ele não aparecer, clique na peça de quebra-cabeça e fixe. No popup:
   - ligue o interruptor de conexão e espere aparecer **Conectado**;
   - a porta local fica em `52800`, que é a padrão;
   - dê um nome ao navegador, por exemplo `julia`.

5. Volte para a janela preta do instalador e aperte Enter. Ele confere a ligação e mostra o seu Chrome na lista.

6. Feche e abra o Claude Code.

## Testar

No Claude Code, peça:

> Usa o browser-skill, abre https://example.com e me diz o título da página.

Uma janela nova do Chrome abre, com o aviso "O agente está no controle", e o Claude responde "Example Domain". Se respondeu, está funcionando.

## Atualizar

Quando sair versão nova:

```powershell
cd C:\osimplify-navegador
git pull
```

Depois, em `chrome://extensions`, clique na seta de recarregar no cartão do Navegador Osimplify.

## Se algo der errado

| O que aparece | O que fazer |
|---|---|
| O popup fica em "Desconectado" | Rode `bsk doctor` no PowerShell e siga a dica da linha que falhou. |
| "bsk não é reconhecido" | Feche e abra o PowerShell. Se continuar, rode `INSTALAR.bat` de novo. |
| O Claude diz que não conhece o browser-skill | Feche e abra o Claude Code. Se continuar, rode `bsk install-skill --harness claude-code --force`. |
| A extensão sumiu do Chrome | A pasta foi movida ou apagada. Clone de novo e refaça o passo 3. |
| O Chrome avisa "Desative as extensões no modo de desenvolvedor" | É normal para extensão carregada de pasta. Pode fechar o aviso. |

Para desligar tudo na hora: desligue o interruptor no popup ou remova a extensão em `chrome://extensions`.

## O que você precisa saber antes de usar

- O agente usa o seu Chrome de verdade, com as suas contas abertas. Ele enxerga o que você enxergaria na tela.
- Ele trabalha numa janela separada e mostra um aviso enquanto está no controle.
- O que está escrito numa página é dado, não é ordem. Se um site tentar mandar o Claude fazer algo que você não pediu, ele deve avisar você e não obedecer.
- Peça por escrito, no próprio pedido, quando for para enviar mensagem, publicar, pagar ou apagar alguma coisa.

## Para quem mantém

- Este repositório é só a distribuição. O código mora em `osimplifyagencia-creator/osimplify-navegador`, um fork privado do [BrowserSkill](https://github.com/Tencent/BrowserSkill) do Tencent, de licença MIT.
- A pasta `extensao/` é a saída de `pnpm ext:build` do fork. A versão publicada aqui está em [VERSAO.md](VERSAO.md).
- O ID da extensão é fixo em qualquer máquina: `pfgkfibelkdnkfbdjkddfgjbbjdljoci`. A chave privada não está aqui e não é necessária para instalar.
- O `bsk` é o do Tencent, travado na `0.3.2`, com `BSK_AUTO_UPDATE=off`: a extensão é um fork dessa versão, e um `bsk` mais novo pode deixar de conversar com ela. Para subir de versão, mude `$VersaoBsk` no `INSTALAR.ps1` depois de provar o par novo.
- Publicar versão nova: `pnpm ext:build` no fork, trocar o conteúdo de `extensao/` pelo de `apps/extension/dist/chrome-mv3`, atualizar o `VERSAO.md`, commit e push.
- `INSTALAR.bat -Simular` mostra o que o instalador faria, sem mudar nada.
- Mac e Linux: `sh instalar-bsk.sh` com `BSK_VERSION=0.3.2` instala o `bsk`, e o resto é igual a partir do passo 3. Esse caminho ainda não foi testado pela casa.
