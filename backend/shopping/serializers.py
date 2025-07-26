from rest_framework import serializers
from .models import ShoppingList, ShoppingListItem

class ShoppingListSerializer(serializers.ModelSerializer):
    class Meta:
        model = ShoppingList
        fields = '__all__'
        read_only_fields = ('user', 'created_at', 'updated_at')

class ShoppingListItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = ShoppingListItem
        fields = '__all__'
