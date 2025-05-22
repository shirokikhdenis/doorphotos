import pandas as pd
import os
from pathlib import Path

# Замените на путь к вашему Excel-файлу
excel_path = r'C:\Users\Denis\Documents\GitHub\doorphotos\photos.xlsx'

# Загрузка таблицы
df = pd.read_excel(excel_path)

# Проход по строкам таблицы
for index, row in df.iterrows():
    full_path = Path(row['FullPath'])  # полный путь к фото
    sku = str(row['SKU']).strip()  # артикул

    if full_path.exists():
        new_name = full_path.parent / (sku + full_path.suffix)
        try:
            os.rename(full_path, new_name)
            print(f"Переименовано: {full_path.name} → {new_name.name}")
        except Exception as e:
            print(f"Ошибка при переименовании {full_path.name}: {e}")
    else:
        print(f"Файл не найден: {full_path}")
