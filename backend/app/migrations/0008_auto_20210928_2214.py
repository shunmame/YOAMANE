# Generated by Django 3.2.5 on 2021-09-28 13:14

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0007_schedules_is_class'),
    ]

    operations = [
        migrations.AlterField(
            model_name='assignments',
            name='complete_time',
            field=models.DateTimeField(blank=True, null=True),
        ),
        migrations.AlterField(
            model_name='assignments',
            name='margin',
            field=models.TimeField(blank=True, null=True),
        ),
    ]
