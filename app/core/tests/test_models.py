"""Tests for models"""

from django.test import TestCase
from django.contrib.auth import get_user_model

class ModelTests(TestCase):
    """Test Models"""

    def test_create_user_with_email_success(self):
        """Test creating a user with email is successful"""
        email = 'test@example.co.za'
        password = '123456'
        user = get_user_model().objects.create_user(email=email, password=password) # type: ignore
        
        self.assertEqual(user.email, email)
        self.assertTrue(user.check_password(password))

    def test_new_user_email_normalized(self):
        """Test email is normalized for users"""
        sample_emails = [
            ["test1@EXAMPLE.com", "test1@example.com"],
            ["Test2@example.com", "test2@example.com"]
        ]

        for email, expected in sample_emails:
            user = get_user_model().objects.create_user(email=email, password='123wefs') # type: ignore
            self.assertEqual(user.email, expected)


    def test_new_user_email_without_email(self):
        """Test error if email left out"""
        with self.assertRaises(ValueError):
            get_user_model().objects.create_user('', 'test123')

    def test_new_super_user(self):
        """Test creating new super user"""

        email = "test@example.com"
        password = 'test123'
        user = get_user_model().objects.create_superuser(
            email=email,
            password=password
        ) # type: ignore

        self.assertEqual(user.email,email )
        self.assertTrue(user.check_password(password))
        
        self.assertTrue(user.is_superuser)
        self.assertTrue(user.is_staff)

