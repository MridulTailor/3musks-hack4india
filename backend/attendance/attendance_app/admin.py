from django.contrib import admin

# Register your models here.
from .models import AttendanceSession ,StudentData
admin.site.register(AttendanceSession)
admin.site.register(StudentData)