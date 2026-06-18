$url1 = "https://zonatv.store/cvatt55.html?get=QXJ0ZWFySEQ&start=true"
$url2 = "https://tvarg1.vercel.app/player.html?get=QXJ0ZWFySEQ&start=true"

$regex = 'tok_[a-zA-Z0-9\-_=]+\.[a-zA-Z0-9\-_=]+\.[a-zA-Z0-9\-_=]+'

function Get-Token($url) {
    try {
        $html = (Invoke-WebRequest -Uri $url -UseBasicParsing).Content
        return ([regex]::Match($html, $regex)).Value
    }
    catch {
        Write-Host "Error consultando $url" -ForegroundColor Red
        return $null
    }
}

$token1 = Get-Token $url1
$token2 = Get-Token $url2

Write-Host "`nToken 1:" -ForegroundColor Cyan
Write-Host $token1

Write-Host "`nToken 2:" -ForegroundColor Cyan
Write-Host $token2

if ($token1 -and $token2) {
    if ($token1 -eq $token2) {
        Write-Host "`n✓ Los tokens son idénticos" -ForegroundColor Green
        $token1 | Set-Clipboard
    }
    else {
        Write-Host "`n✗ Los tokens son diferentes" -ForegroundColor Yellow

        # Comparar payload JWT
        $parts1 = $token1 -split '\.'
        $parts2 = $token2 -split '\.'

        if ($parts1.Count -eq 3 -and $parts2.Count -eq 3) {
            Write-Host "Header igual : $($parts1[0] -eq $parts2[0])"
            Write-Host "Payload igual: $($parts1[1] -eq $parts2[1])"
            Write-Host "Firma igual  : $($parts1[2] -eq $parts2[2])"
        }
    }
}
else {
    Write-Host "`nNo se pudo obtener uno o ambos tokens." -ForegroundColor Red
}
$token1 = Get-Token $url1   # zonatv.store
$token2 = Get-Token $url2   # vercel

if ($token1) {
    $token1 | Set-Clipboard
    Write-Host "✓ Token de zonatv.store copiado al portapapeles" -ForegroundColor Green
}

if ($token1 -and $token2) {
    if ($token1 -eq $token2) {
        Write-Host "✓ Los tokens son idénticos" -ForegroundColor Green
    }
    else {
        Write-Host "✗ Los tokens son diferentes" -ForegroundColor Yellow
    }
}
