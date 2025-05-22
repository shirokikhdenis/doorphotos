# Включаем отображение ошибок
$ErrorActionPreference = "Stop"

# Список выражений
$patterns = @(
    "Magic Fog",
    "Black Star",
    "Black Silk",
    "Magic Moru",
    "White Сrystal",  # ВНИМАНИЕ: тут кириллическая "С", если в файле тоже кириллица — оставляем
    "Black Shine",
    "Mirox Grey"
)

# Получаем все файлы в текущей папке
Get-ChildItem -File | ForEach-Object {
    try {
        $originalName = $_.BaseName
        $extension = $_.Extension

        # Сохраняем порядок появления выражений в имени
        $found = @()
        foreach ($pattern in $patterns) {
            if ($originalName -like "*$pattern*") {
                $found += $pattern
            }
        }

        if ($found.Count -gt 0) {
            # Удаляем все найденные выражения из имени
            $newName = $originalName
            foreach ($pattern in $found) {
                $escaped = [regex]::Escape($pattern)
                $newName = [regex]::Replace($newName, $escaped, "", "IgnoreCase")
            }

            # Удаляем лишние пробелы
            $newName = $newName.Trim() -replace '\s{2,}', ' '

            # Добавляем найденные выражения в конец
            $finalName = ($newName + " " + ($found -join " ")).Trim()

            # Формируем новое имя файла
            $newFileName = $finalName + $extension

            Write-Host "Переименование: '$($_.Name)' → '$newFileName'"
            Rename-Item -LiteralPath $_.FullName -NewName $newFileName
        }
    }
    catch {
        Write-Host "Ошибка при обработке '$($_.Name)': $_" -ForegroundColor Red
    }
}
