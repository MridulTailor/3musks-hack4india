# Generated by Django 4.1.7 on 2023-10-06 12:51

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("attendance_app", "0001_initial"),
    ]

    operations = [
        migrations.CreateModel(
            name="AdditionalData",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("username", models.CharField(max_length=100)),
                ("session_id", models.CharField(max_length=100)),
                ("wifi_id", models.CharField(max_length=100)),
            ],
        ),
    ]
