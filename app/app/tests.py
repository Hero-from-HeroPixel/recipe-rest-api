"""Sample Tests"""

from django.test import SimpleTestCase
from app import calc


class CalcTests(SimpleTestCase):
    """Test the calc module"""

    def test_add_numbers(self):
        """Add 2 nums"""
        res = calc.add(5, 6)
        self.assertEqual(res, 11)

    def test_subtract_numbers(self):
        """Subtract 2 nums"""
        res = calc.subtract(6, 5)
        self.assertEqual(res, 1)
