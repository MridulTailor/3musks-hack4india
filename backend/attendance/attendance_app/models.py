# from django.db import models

# # Create your models here.
# from django.db import models
# from django.utils import timezone

# class AttendanceSession(models.Model):
#     start_time = models.DateTimeField(default=timezone.now)
#     end_time = models.DateTimeField(null=True, blank=True)
#     is_active = models.BooleanField(default=True)

#     def __str__(self):
#         return f"Session {self.id}: {self.start_time} - {self.end_time if self.end_time else 'Ongoing'}"


from django.db import models
from django.utils import timezone

class AttendanceSession(models.Model):
    start_time = models.DateTimeField(default=timezone.now)
    end_time = models.DateTimeField(null=True, blank=True)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return f"Session {self.id}: {self.start_time} - {self.end_time if self.end_time else 'Ongoing'}"

class StudentData(models.Model):
    username = models.CharField(max_length=100)
    session_id = models.CharField(max_length=100)
    wifi_id = models.CharField(max_length=100)
    date = models.CharField(max_length=50)
    checkIn = models.CharField(max_length=100)


    def __str__(self):
        return f"StudentDataa - Username: {self.username}, SessionID: {self.session_id}, WifiID: {self.wifi_id}"
