<#
.SYNOPSIS
Instala o Navegador Osimplify neste computador.

.DESCRIPTION
Faz quatro coisas, nesta ordem:
  1. Instala a ferramenta bsk (a ponte entre o Claude e o Chrome), na versão que casa com a nossa extensão.
  2. Desliga a atualização automática do bsk, para ele não trocar de versão sozinho.
  3. Instala a skill browser-skill no Claude Code.
  4. Abre o Chrome na tela de extensões e confere a ligação.

O jeito mais fácil de rodar é dar dois cliques no INSTALAR.bat.

.PARAMETER Simular
Mostra o que seria feito, sem instalar nem mudar nada.
#>

#Requires -Version 5.1

param([switch]$Simular)

$ErrorActionPreference = "Stop"

$VersaoBsk = "0.3.2"
$Raiz = $PSScriptRoot
$PastaExtensao = Join-Path $Raiz "extensao"

function Passo {
    param([string]$Texto)
    Write-Host ""
    Write-Host "==> $Texto" -ForegroundColor Cyan
}

function Achar-Bsk {
    $comando = Get-Command bsk -ErrorAction SilentlyContinue
    if ($comando) { return $comando.Source }
    $padrao = Join-Path $HOME ".local\bin\bsk.exe"
    if (Test-Path -LiteralPath $padrao) { return $padrao }
    return $null
}

if (-not (Test-Path -LiteralPath (Join-Path $PastaExtensao "manifest.json"))) {
    Write-Host "Não achei a pasta 'extensao' ao lado deste arquivo. Clone o repositório inteiro e rode de novo." -ForegroundColor Red
    exit 1
}

# 1. bsk
Passo "1 de 4: ferramenta bsk $VersaoBsk"
$bsk = Achar-Bsk
$versaoAtual = $null
if ($bsk) { $versaoAtual = ((& $bsk --version) -replace '^bsk\s+', '').Trim() }

if ($versaoAtual -eq $VersaoBsk) {
    Write-Host "Já instalada em $bsk."
}
elseif ($Simular) {
    Write-Host "[simulação] Instalaria o bsk $VersaoBsk em $HOME\.local\bin (hoje: $versaoAtual)."
}
else {
    $env:BSK_VERSION = $VersaoBsk
    & (Join-Path $Raiz "instalar-bsk.ps1")
    $bsk = Achar-Bsk
    if (-not $bsk) {
        Write-Host "O bsk não foi instalado. Copie o erro acima e mande para o Nilton." -ForegroundColor Red
        exit 1
    }
    Write-Host "Instalada em $bsk."
}

# 2. atualização automática
Passo "2 de 4: travar a versão do bsk"
if ($Simular) {
    Write-Host "[simulação] Gravaria BSK_AUTO_UPDATE=off nas variáveis do seu usuário."
}
else {
    [Environment]::SetEnvironmentVariable("BSK_AUTO_UPDATE", "off", "User")
    $env:BSK_AUTO_UPDATE = "off"
    Write-Host "Atualização automática desligada."
}

# 3. skill do Claude Code
Passo "3 de 4: skill do Claude Code"
$temClaude = Test-Path -LiteralPath (Join-Path $HOME ".claude")
if (-not $temClaude) {
    Write-Host "Não achei o Claude Code neste usuário. Instale o Claude Code e rode este instalador de novo." -ForegroundColor Yellow
}
elseif ($Simular) {
    Write-Host "[simulação] Rodaria: bsk install-skill --harness claude-code"
}
else {
    & $bsk install-skill --harness claude-code
    if ($LASTEXITCODE -ne 0) {
        Write-Host "A skill não foi instalada. Copie o erro acima e mande para o Nilton." -ForegroundColor Red
        exit 1
    }
}

# 4. extensão no Chrome
Passo "4 de 4: extensão no Chrome"
Write-Host "Pasta da extensão: $PastaExtensao"
Write-Host ""
Write-Host "No Chrome que vai abrir:"
Write-Host "  a) ligue o 'Modo do desenvolvedor' (canto de cima, à direita);"
Write-Host "  b) clique em 'Carregar sem compactação';"
Write-Host "  c) cole o caminho da pasta (já está copiado) e confirme;"
Write-Host "  d) clique no ícone do Navegador Osimplify e ligue o interruptor de conexão."

if ($Simular) {
    Write-Host ""
    Write-Host "[simulação] Copiaria o caminho da pasta e abriria chrome://extensions. Nada foi instalado." -ForegroundColor Yellow
    exit 0
}

Set-Clipboard -Value $PastaExtensao
try { Start-Process "chrome.exe" "chrome://extensions" } catch {
    Write-Host "Não consegui abrir o Chrome sozinho. Abra o Chrome e digite chrome://extensions na barra de endereço." -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Quando o popup mostrar 'Conectado', aperte Enter aqui" | Out-Null

& $bsk doctor
Write-Host ""
& $bsk browsers
Write-Host ""
Write-Host "Se o seu Chrome aparece na lista acima, está pronto. Feche e abra o Claude Code antes de usar." -ForegroundColor Green
