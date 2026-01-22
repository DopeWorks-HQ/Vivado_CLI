# Generate read_verilog lines and PREPEND them to synth.tcl
# Searches ../rtl and all subdirectories

$outFile = "Windows\synth.tcl"
$tmpFile = New-TemporaryFile

# Resolve ../rtl relative to where the script is run
$searchRoot = Resolve-Path "rtl"

# Generate read_verilog lines
$lines =
    Get-ChildItem $searchRoot -Recurse -File |
    Where-Object { $_.Extension -in '.v', '.sv' } |
    Sort-Object FullName |
    ForEach-Object {
        # Strip leading ../ so paths look like rtl/...
        $p = $_.FullName.Replace((Resolve-Path "..").Path + '\', '')
        if ($_.Extension -eq '.sv') {
            "read_verilog -sv $p"
        } else {
            "read_verilog $p"
        }
    }

# Write new lines first
$lines | Out-File -Encoding ASCII $tmpFile

# Blank line separator
"" | Out-File -Append -Encoding ASCII $tmpFile

# Append existing file unchanged
if (Test-Path $outFile) {
    Get-Content $outFile | Out-File -Append -Encoding ASCII $tmpFile
}

# Replace original file
Move-Item $tmpFile $outFile -Force

Write-Host "Updated $outFile"
