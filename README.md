# elevator_atmega32
just a simple elevator controller circuit (atmega32, C lang)
english description maybe added but not right now :( sorry :D
## یادداشت
به پیشنهاد چندتا از دوستانم وسواس رو کنار گذاشتم و میخوام یه سری از پروژه های دانشگاهیم رو اینجا بذارم که اینقدر خالی نباشه، هر چند که ممکنه اونقدر که خودم ازشون راضی باشم خوب نباشن.
فعلا این پروژه رو میذارم اینجا بمونه و هر وقت که فرصت شده کارهای زیر رو انجام میدم:
1- این فایل رو کامل تر میکنم تا توضیحات کامل تر و واضح تر باشن
2- احتمالا ویدئویی ضبط میکنم و پروژه رو توش توضیح میدم و روی یوتوب میذارم (که لینکش اضافه میشه)
3- احتمالا اشکالاتی که گفتم رو برطرف میکنم و نتیجه رو کامیت میکنم
4- نمودار حالت و تصاویر دیگه ای که به فهم پروژه کمک میکنند رو به این فایل اضافه میکنم


## توضیحات پروژه
این ریپازیتوری شامل فایل پروتئوس و سورس کد سی پروژه‌ی من برای درس ریزپردازنده و زبان اسمبلیه که یه مدار ساده برای کنترل یک آسانسوره که با استفاده از ریزپردازنده ی اتمگا 32 پیاده سازی شده و با زبان c پروگرم شده.
پروژه مربوط به درسی هست که در ترم 4012 در دانشکده فنی دانشگاه گیلان و گروه مهندسی کامپیوتر توسط جناب دکتر پدرام احمدی فر ارائه شده. صورت پروژه به صورت یک فایل پی دی اف در ریپازیتوری موجوده.

## توضیحات مدار
این آسانسور دو تا موتور داره که یکی برای باز و بسته شدن در آسانسور و اون یکی برای بالا و پایین بردن کابین بین طبقات هست. همچنین یک سون سگمنت داریم که شماره طبقه ای که آسانسور توش حضور داره رو نشون میده و وقتی در آسانسور باز یا بسته میشه چشمک میزنه. نه دکمه داریم که چهارتا از اون ها دکمه های درخواست آسانسور هستن که در طبقات قرار دارن، چهارتا از اون ها دکمه های انتخاب طبقه هستن که توی کابین قرار دارن و دکمه ی آلارم که باعث میشه آسانسور در اولین طبقه ای که سر راهش هست توقف کنه و بعد به مسیرش ادامه بده. همچنین الگوریتم این آسانسور سنسور وزن و مادون قرمز رو هم ساپورت میکنن که به دلیل کمبود وقت در زمان انجام پروژه به صورت ورودی منطقی دریافت میشن که بهتره از ورودی آنالوگ به دیجیتال استفاده میشد (احتمالا اگه وقتی پیدا شد بعدا این رو اوکی کنم).

## توضیحات کد
برای پیاده سازی منطق این مدار وضعیت آسانسور رو به حالت های مختلفی تقسیم کردم (چیزی شبیه به DFA براش رسم کردم که بعدا به این توضیحات اضافه میکنم) که سیستم در هر وضعیت رفتار مشخصی دارد و میتواند از هر کدام از وضعیت ها در شرایطی به وضعیت دیگری منتقل شود. وضعیت ها به شرح زیر اند.
### وضعیت 0: در باید باز شود
این وضعیت در هر پالس ساعت یک واحد در را باز تر میکند. اگر در کاملا باز باشد به وضعیت 1 منتقل میشود.
### وضعیت 1: باز ماندن در
در این وضعیت پالس های ساعت شمرده میشوند و اگر به مقدار خاصی برسند (تعداد پالس هایی که باید بعد از بااز کردن در بگذرد تا در شروع به بسته شدن بکند) به وضعیت 2 منتقل میشود.
### وضعیت 2: در باید بسته شود
در این وضعیت در هر پالس ساعت اگر سنسور مادون قرمز فعال شود (وجود مانع) به وضعیت 0 منتقل میشود در غیر این صورت در یک واحد بسته تر میشود و اگر در کاملا بسته شد به وضعیت 3 میرود.
### وضعیت 3: مشخص کردن مقصد
در این وضعیت اگر طبقه ای به عنوان مقصد بعدی مشخص شود یا سنسور وزن (غیر مجاز بودن وزن) یا دکمه آلارم فعال شوند به وضعیت 4 میرود.
### وضعیت 4: حرکت به سمت مقصد
در این وضعیت اگر به مقصد رسیده بود (ارتفاع از زمین برابر با ارتفاع مقصد بود) به وضعیت 0 منقل میشد در غیر این صورت در هر پالس از ساعت یک واحد به جهت سمت مقصد حرکت میکند (دستور به موتور بالابر)

## اشکالات
به دلیل وقت محدودی که برای پیاده سازی پروژه داشتم پروژه اشکالاتی دارد که میتواند بر طرف شود. مثلا وضعیت 0 و 1 میتوانند با هم ادغام شوند. برای سنسور مادون قرمز و وزن میشود از انالوگ به دیجیتال استفاده کرد. کدها و مدار دکمه ها میتونن بهتر بشن و کد هم میتونه به طور کلی تمیزتر بشه.
الگوریتم انتخاب مقصد پروژه بر اساس صورت پروژه پیاده سازی شده که میتونه باعث پدیده گرسنگی بشه (آسانسور در شرایطی هیچوقت در بعضی طبقات توقف نکنه) و البته مقدار حرکت بهینه ای نداشته باشه. الگوریتمی مثل look برای این کاربرد بهتره به نظرم و احتمالا اگر پروژه آپدیتی بگیره این جزو اون ها خواهد بود.
خلاصه که از مشارکتتون استقبال میکنم و البته اگه توی پروداکشن استفاده کردید من مسئولیت تلفات رو به عهده نمیگیرم (LOL)

## اجرای پروژه
برای اجرای این پروژه شما نیاز به نرم افزار پروتئوس و یک کامپایلر برای اتمگا 32 دارید (که من از codevision-avr استفاده کردم و فایلی که قرار دادم یک پروژه توی این محیطه)
سورس را با استفاده از کامپایلرتون به کد هگز کامپایل کنید (این کار برای نسخه فعلی انجام شده)
سپس پروژه پروتئوس را باز کنید. روی میکروکنترلر دابل کلیک کنید و آدرس فایل هگز را به آن بدهید و بعد از انجام این کار پروژه را با استفاده از دکمه ی پایین سمت چپ ران کنید.
