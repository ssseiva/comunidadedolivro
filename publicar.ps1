# Copia o texto do site do cofre do Obsidian para index.md e publica no GitHub Pages.
$ErrorActionPreference = 'Stop'
$nota = 'G:\Meu Drive\3. Resources\Infraestrutura digital\Cofre\01 Projetos\Cursos\Comunidade do Livro\site de apresentação.md'
$repo = $PSScriptRoot
$site = 'https://ssseiva.github.io/comunidadedolivro/'

function Fim($msg) {
  Write-Host ''
  Write-Host $msg
  Read-Host 'Enter para fechar' | Out-Null
  exit
}

if (-not (Test-Path -LiteralPath $nota)) { Fim "Não achei a nota: $nota" }

$texto = [IO.File]::ReadAllText($nota, [Text.Encoding]::UTF8)
[IO.File]::WriteAllText((Join-Path $repo 'index.md'), "---`n---`n" + $texto, (New-Object Text.UTF8Encoding $false))

git -C $repo add -A
if (-not (git -C $repo status --porcelain)) { Fim 'Nada mudou desde a última publicação.' }

git -C $repo commit -q -m "Atualiza o texto do site"
git -C $repo push -q
if ($LASTEXITCODE -ne 0) { Fim 'O envio para o GitHub falhou. Confira a internet e tente de novo.' }

Fim "Publicado. O site atualiza em 1 ou 2 minutos: $site"
