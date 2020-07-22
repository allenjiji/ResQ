# Generated by Django 3.0.7 on 2020-07-22 08:39

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('flood', '0002_auto_20200722_0833'),
    ]

    operations = [
        migrations.AddField(
            model_name='userprofile',
            name='address',
            field=models.CharField(default=None, max_length=200),
        ),
        migrations.AddField(
            model_name='userprofile',
            name='areaofvol',
            field=models.CharField(default=None, max_length=40),
        ),
        migrations.AddField(
            model_name='userprofile',
            name='district',
            field=models.CharField(default=None, max_length=30),
        ),
        migrations.AlterField(
            model_name='userprofile',
            name='is_volunteer',
            field=models.BooleanField(),
        ),
    ]