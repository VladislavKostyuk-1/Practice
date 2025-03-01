# Практика 2025
# Костюк Владислав ІПЗ-4.01
# Завдання

1. Створення класів сутностей
2. Реалізація системи компоеннтів
3. Імплементація системи отримання та нанесення пошкоджень

# Виконані завдання

1. Мною було створено клас сутностей Entity, а також похідні від нього класи. Цей клас відповідає за загальну поведінку сутностей, як наприклад вороги та гравець.
А саме - зберігає напрям погляду сутності, управляє штучно створеною висотою сутності, а також зберігає посилання на такі елементи сутності як її хітбокс,
хартбокс та машина станів. Від класу Entity були створені похідні класи player, що відповідає за керування гравцем, та Enemy, що відповідає за поведінку ворога.
При створенні окремих ворогів створюється новий клас похідний від Enenmy, для більш гнучкого налаштування ворога. На рисунку 1 зображено розташування класів у
файловій системі проєкту:

![image_alt](https://github.com/VladislavKostyuk-1/Practice/blob/add1292970ab91f67fe8aeff6540bb69ae57616f/Screenshots/Kostyuk/1.jpg)

  рисунок 1

2. Було реалізовано систему компонентів. Компоненти - це (в основному) порожні об'єкти, що можна додавати до різних об'ктів, як наприклад ворог, для додавання
певного функціоналу. Компоненти зручні тим що код конкретної системи можна зберігати в окремому скрипті, що робить загальний код більш зручним для розуміння,
а також за допомогою компонентів можна контролювати додатковий функціонал об'кта динамічно вставляючи їх в цей об'єкт. На рисунку 2 зображено ієрархію сцени Slime,
на якій видно компоненти Health, що відповідає за здоров'я сутності, а також AntiCoupling, за допомогою якого вороги цього типу будуть менше скупчуватися в одній
точці.

![image_alt](https://github.com/VladislavKostyuk-1/Practice/blob/add1292970ab91f67fe8aeff6540bb69ae57616f/Screenshots/Kostyuk/2.jpg)

  рисунок 2

3. Система отримання та нанесення пошкоджень працює за допомогою об'єктів HitBox та HurtBox. Коли ці два об'єкти торкаються один одного, то сутність, якій належить
HurtBox, наносить пошкодження сутності якій належить HitBox. На рисунку 3 зображені гравець та слайм з видимими колізіями, HitBox відображений у вигляді зеленого
прямокутника, а HurtBox - у вигляді червоного.

![image_alt](https://github.com/VladislavKostyuk-1/Practice/blob/add1292970ab91f67fe8aeff6540bb69ae57616f/Screenshots/Kostyuk/3.jpg)

  рисунок 3
