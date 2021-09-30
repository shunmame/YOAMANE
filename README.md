# YOAMANE

## file tree
.
├── backend
│   ├── YOAMANE_dev
│   │   ├── __init__.py
│   │   ├── asgi.py
│   │   ├── settings.py
│   │   ├── urls.py
│   │   └── wsgi.py
│   ├── app
│   │   ├── __init__.py
│   │   ├── admin.py
│   │   ├── apps.py
│   │   ├── common_schedule.py
│   │   ├── insert_schedule_of_timetable.py
│   │   ├── migrations
│   │   │   ├── 0001_initial.py
│   │   │   ├── 0002_alter_todolists_estimated_work_time.py
│   │   │   ├── 0003_auto_20210924_0419.py
│   │   │   ├── 0004_auto_20210924_0421.py
│   │   │   ├── 0005_auto_20210924_0422.py
│   │   │   ├── 0006_auto_20210924_1436.py
│   │   │   ├── 0007_schedules_is_class.py
│   │   │   ├── 0008_auto_20210928_2214.py
│   │   │   └── __init__.py
│   │   ├── models.py
│   │   ├── serializer.py
│   │   ├── tests.py
│   │   ├── urls.py
│   │   └── views.py
│   ├── manage.py
│   └── static
│       ├── admin
│       ├── rest_framework
│       └── rest_framework_swagger
|
└── frontend
    ├── README.md
    └── yoamane
        ├── README.md
        ├── lib
        │   ├── api_sample
        │   │   ├── delete_sample.dart
        │   │   ├── get_sample.dart
        │   │   ├── post_sample.dart
        │   │   └── put_sample.dart
        │   ├── api_sample.dart
        │   ├── assignment_detail.dart
        │   ├── assignment_form.dart
        │   ├── assignment_list.dart
        │   ├── calendar.dart
        │   ├── friend_form.dart
        │   ├── friend_list.dart
        │   ├── login.dart
        │   ├── logout.dart
        │   ├── main.dart
        │   ├── notification.dart
        │   ├── schedule_form.dart
        │   ├── schedule_list.dart
        │   ├── select_working_time.dart
        │   ├── subject_form.dart
        │   ├── tag_form.dart
        │   ├── termination_message.dart
        │   ├── timetable.dart
        │   ├── timetable_form.dart
        │   ├── timetable_list.dart
        │   ├── timetable_time_form.dart
        │   ├── user_data.dart
        │   ├── yoamane_api.dart
        │   └── yoamane_libraries.dart
        ├── pubspec.lock
        └──pubspec.yaml
