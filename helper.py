import boto3
import os
import json
from datetime import datetime
from redmail import EmailSender
from botocore.exceptions import ClientError

with open("config.json", "r") as f:
    config = json.load(f)


smtp_user = os.environ["SMTP_USER"]
smtp_password = os.environ["SMTP_PASSWORD"]


class Email:
    def __init__(self, email_to: str) -> None:
        self.email_to = email_to
        self._email = EmailSender(
            host="smtp.gmail.com",
            port=465,
            username=smtp_user,
            password=smtp_password,
        )

        tdy = datetime.now().strftime("%Y-%m-%d")
        self._subject = f"Job Report for {tdy}"

    def send_email(self, html: str) -> None:
        try:
            self._email.send(
                subject=self._subject,
                sender="budgetTracket@gmail.com",
                receivers=self.email_to,
                html=html,
            )
            print(f"Email sent successfully to {self.email_to}")
        except Exception as e:
            print(f"Email sending to {self.email_to} failed: {e}")
            raise
