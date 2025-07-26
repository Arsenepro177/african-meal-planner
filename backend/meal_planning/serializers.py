from rest_framework import serializers
from .models import MealPlan, MealPlanEntry

class MealPlanSerializer(serializers.ModelSerializer):
    class Meta:
        model = MealPlan
        fields = '__all__'
        read_only_fields = ('user', 'created_at', 'updated_at')

class MealPlanEntrySerializer(serializers.ModelSerializer):
    class Meta:
        model = MealPlanEntry
        fields = '__all__'
