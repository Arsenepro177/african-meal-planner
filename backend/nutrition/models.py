from django.db import models

class NutritionInfo(models.Model):
    name = models.CharField(max_length=100)
    calories_per_100g = models.FloatField()
    protein_per_100g = models.FloatField()
    carbs_per_100g = models.FloatField()
    fat_per_100g = models.FloatField()
    fiber_per_100g = models.FloatField(null=True, blank=True)
    sugar_per_100g = models.FloatField(null=True, blank=True)
    
    def __str__(self):
        return self.name
