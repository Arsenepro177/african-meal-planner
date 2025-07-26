from django.shortcuts import render
from rest_framework import generics, permissions
from .models import ShoppingList, ShoppingListItem
from .serializers import ShoppingListSerializer, ShoppingListItemSerializer

class ShoppingListListCreateView(generics.ListCreateAPIView):
    serializer_class = ShoppingListSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return ShoppingList.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

class ShoppingListDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = ShoppingListSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return ShoppingList.objects.filter(user=self.request.user)

class ShoppingListItemListCreateView(generics.ListCreateAPIView):
    serializer_class = ShoppingListItemSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        shopping_list_id = self.kwargs.get('shopping_list_id')
        return ShoppingListItem.objects.filter(
            shopping_list__id=shopping_list_id,
            shopping_list__user=self.request.user
        )

class ShoppingListItemDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = ShoppingListItemSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return ShoppingListItem.objects.filter(shopping_list__user=self.request.user)
