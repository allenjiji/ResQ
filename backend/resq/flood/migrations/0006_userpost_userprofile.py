# Generated by Django 3.0.7 on 2020-07-22 14:16

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('flood', '0005_auto_20200722_0847'),
    ]

    operations = [
        migrations.AddField(
            model_name='userpost',
            name='userprofile',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL),
        ),
    ]