# Generated by Django 2.0.3 on 2018-03-31 19:23

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='ListModel',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('choice', models.CharField(choices=[('Colostethus fraterdanieli', 'Colostethus fraterdanieli'), ('Diasporus gularis', 'Diasporus gularis'), ('New folder', 'New folder')], max_length=1)),
            ],
        ),
    ]
