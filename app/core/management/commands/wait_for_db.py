import time

from psycopg import OperationalError as PsycopgError
from django.db.utils import OperationalError
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    """Django command to wait for the db."""

    def handle(self, *args, **options):
        """Entrypoint for command"""

        self.stdout.write("Waiting for db...")
        db_up = False
        retries = 0
        while retries < 3 and db_up is False:
            try:
                self.check(databases=["default"])  # pyright: ignore[reportCallIssue]
                db_up = True
            except (PsycopgError, OperationalError):
                retries += 1
                time.sleep(1)
        self.stdout.write(
            self.style.ERROR("Failed to establish db connection.")
            if db_up is False
            else self.style.SUCCESS("Database available!")
        )
