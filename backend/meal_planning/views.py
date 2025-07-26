from django.shortcuts import render
from rest_framework import generics, permissions
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import MealPlan, MealPlanEntry
from .serializers import MealPlanSerializer, MealPlanEntrySerializer

class MealPlanListCreateView(generics.ListCreateAPIView):
    serializer_class = MealPlanSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return MealPlan.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

class MealPlanDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = MealPlanSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return MealPlan.objects.filter(user=self.request.user)

class MealPlanEntryListCreateView(generics.ListCreateAPIView):
    serializer_class = MealPlanEntrySerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        meal_plan_id = self.kwargs.get('meal_plan_id')
        return MealPlanEntry.objects.filter(
            meal_plan__id=meal_plan_id,
            meal_plan__user=self.request.user
        )

class MealPlanEntryDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = MealPlanEntrySerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return MealPlanEntry.objects.filter(meal_plan__user=self.request.user)
