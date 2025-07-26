from rest_framework import serializers
from .models import NutritionInfo

class NutritionInfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = NutritionInfo
        fields = '__all__'
