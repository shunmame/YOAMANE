# Generated by Django 3.2.5 on 2021-10-05 01:53

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0011_auto_20211004_0917'),
    ]

    operations = [
        migrations.AlterField(
            model_name='assignments',
            name='collaborating_group',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='assignment_group_id', to='app.groupnames'),
        ),
        migrations.AlterField(
            model_name='schedules',
            name='collaborating_group',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='schedule_group_id', to='app.groupnames'),
        ),
        migrations.AlterField(
            model_name='todolists',
            name='collaborating_group',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='todolist_group_id', to='app.groupnames'),
        ),
    ]