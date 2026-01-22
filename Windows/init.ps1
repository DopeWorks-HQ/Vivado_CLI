# Generate read_verilog lines and PREPEND them to read_files.ys

$outFile = "synth.tcl"
$tmpFile = New-TemporaryFile
$root    = (Get-Location).Path + '\'

# Generate read_verilog lines
$lines =
    Get-ChildItem -Recurse -File |
    Where-Object { $_.Extension -in '.v', '.sv' } |
    Sort-Object FullName |
    ForEach-Object {
        $p = $_.FullName.Replace($root, '')
        if ($_.Extension -eq '.sv') {
            "read_verilog -sv $p"
        } else {
            "read_verilog $p"
        }
    }

# Write new lines first
$lines | Out-File -Encoding ASCII $tmpFile

# Add blank line for readability
"" | Out-File -Append -Encoding ASCII $tmpFile

# Append existing file if it exists
if (Test-Path $outFile) {
    Get-Content $outFile | Out-File -Append -Encoding ASCII $tmpFile
}

# Replace original file
Move-Item $tmpFile $outFile -Force

Write-Host "Updated $outFile"
