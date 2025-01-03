﻿**Отчет**

**Фамилия, Имя, Отчество:**
Киндаров Ибрагим Муслимович

**Группа:**
БПИ237

**Вариант задания:**
Вариант 14

**Условие задачи:**
Разработать программу, вычисляющую с помощью степенного ряда с точностью не хуже 0,1% значение функции гиперболического котангенса cth(x) = (e^x + e^−x)/(e^x − e^−x) для заданного параметра x.

**Метод нахождения значения ф-ии:**
![image](https://github.com/user-attachments/assets/6a253fcd-d479-4e82-b706-b7b239c8b018)

**Программа**

Программа написана на языке ассемблера для архитектуры RISC-V и выполняет следующие функции:

1. **Ввод параметра x с клавиатуры и проверка значения**:
   1. Программа запрашивает ввод значения x и проверяет, что оно не равно нулю. Этот ввод выполняется с использованием макросов для обеспечения удобного взаимодействия с пользователем.
1. **Вычисление гиперболического котангенса cth(x) и вывод результата**:
   1. Программа вычисляет значение гиперболического котангенса cth(x) ​, используя разложение в степенной ряд для вычисления e^x с высокой точностью (не хуже 0,1%).
   1. Затем программа сравнивает полученное значение cth(x) с заданным значением y, проверяя, попадает ли результат в диапазон [y \* (1 - precision), y \* (1 + precision)]. Если значение попадает в диапазон, выводится TRUE, в противном случае — FALSE.
   1. Программа выводит результат в формате "{x} , {y} - {TRUE/FALSE} , CTH(x) = {real\_value}" или просто значение cth(x), если проверка с y не выполняется.
1. **Возможность перезапуска программы**:
   1. После вывода результата программа предлагает пользователю повторно ввести новое значение x и вычислить cth(x). Если пользователь вводит 0, программа завершает выполнение. При любом другом вводе программа перезапускается, позволяя вводить и обрабатывать новые значения.
1. **Автоматизированное тестирование с различными значениями x и y**:
   1. Программа дополнена модулем автоматического тестирования, который прогоняет различные наборы входных данных для проверки корректности вычислений.
   1. Для сравнения результатов и проверки точности написана тестовая программа на Python, которая использует стандартные библиотеки для вычисления гиперболического котангенса.

**Итог**

Программа успешно прошла все тесты и отвечает требованиям для оценки на 10 баллов:

- Реализованы подпрограммы и макросы для ввода-вывода, которые поддерживают повторное использование с различными входными и выходными параметрами.
- Подпрограммы используют стек для сохранения значений временных регистров, что позволяет изолировать подпрограммы и гарантировать сохранение значений при вызове.
- Проведено автоматизированное тестирование и проверка корректности вычислений с использованием библиотеки Python.
- Программа разбита на несколько единиц компиляции, макросы вынесены в отдельную библиотеку, а ввод-вывод представлен отдельным модулем для повторного использования.

Таким образом, все требования к работе на оценку 10 баллов выполнены.


