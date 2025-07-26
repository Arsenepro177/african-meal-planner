"""
Supabase client service for African Meal Planner Django backend
"""

from supabase import create_client, Client
from django.conf import settings
import logging

logger = logging.getLogger(__name__)


class SupabaseService:
    """Service class for Supabase operations"""
    
    def __init__(self):
        self.client: Client = None
        self._initialize_client()
    
    def _initialize_client(self):
        """Initialize Supabase client"""
        try:
            if settings.SUPABASE_URL and settings.SUPABASE_SERVICE_ROLE_KEY:
                self.client = create_client(
                    settings.SUPABASE_URL,
                    settings.SUPABASE_SERVICE_ROLE_KEY
                )
                logger.info("Supabase client initialized successfully")
            else:
                logger.warning("Supabase URL or Service Role Key not configured")
        except Exception as e:
            logger.error(f"Failed to initialize Supabase client: {str(e)}")
    
    def get_client(self) -> Client:
        """Get Supabase client instance"""
        return self.client
    
    def is_configured(self) -> bool:
        """Check if Supabase is properly configured"""
        return self.client is not None
    
    def upload_file(self, bucket_name: str, file_path: str, file_data: bytes) -> dict:
        """Upload file to Supabase Storage"""
        try:
            if not self.client:
                return {"error": "Supabase client not configured"}
            
            result = self.client.storage.from_(bucket_name).upload(
                file_path, 
                file_data
            )
            
            if result.get('error'):
                logger.error(f"File upload failed: {result['error']}")
                return {"error": result['error']}
            
            # Get public URL
            public_url = self.client.storage.from_(bucket_name).get_public_url(file_path)
            
            return {
                "success": True,
                "path": file_path,
                "public_url": public_url
            }
            
        except Exception as e:
            logger.error(f"File upload error: {str(e)}")
            return {"error": str(e)}
    
    def delete_file(self, bucket_name: str, file_path: str) -> dict:
        """Delete file from Supabase Storage"""
        try:
            if not self.client:
                return {"error": "Supabase client not configured"}
            
            result = self.client.storage.from_(bucket_name).remove([file_path])
            
            if result.get('error'):
                logger.error(f"File deletion failed: {result['error']}")
                return {"error": result['error']}
            
            return {"success": True}
            
        except Exception as e:
            logger.error(f"File deletion error: {str(e)}")
            return {"error": str(e)}
    
    def get_file_url(self, bucket_name: str, file_path: str) -> str:
        """Get public URL for a file"""
        try:
            if not self.client:
                return None
            
            return self.client.storage.from_(bucket_name).get_public_url(file_path)
            
        except Exception as e:
            logger.error(f"Get file URL error: {str(e)}")
            return None


# Global instance
supabase_service = SupabaseService()
