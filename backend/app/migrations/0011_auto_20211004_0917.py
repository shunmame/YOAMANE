# Generated by Django 3.2.5 on 2021-10-04 00:17

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0010_alter_todolists_user'),
    ]

    operations = [
        migrations.AlterField(
            model_name='grouptags',
            name='create_user',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='create_user', to=settings.AUTH_USER_MODEL),
        ),
        migrations.AlterField(
            model_name='grouptags',
            name='groupname',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='app.groupnames'),
        ),
        migrations.AlterField(
            model_name='grouptags',
            name='user',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='grouptag_user', to=settings.AUTH_USER_MODEL),
        ),
    ]
