import os
import json
import logging
from datetime import datetime
from redmail import EmailSender

with open("config.json", "r") as f:
    config = json.load(f)

class Email:
    def __init__(self, email_to: str) -> None:
        self.email_to = email_to
        self._email = EmailSender(
            host=config["smtp_host"],
            port=config["smtp_port"],
            username=os.environ["SMTP_USER"],
            password=os.environ["SMTP_PASSWORD"],
        )

        tdy = datetime.now().strftime("%Y-%m-%d")
        self._subject = f"Job Report for {tdy}"

    def send_email(self, html: str) -> None:
        try:
            self._email.send(
                subject=self._subject,
                sender="studentServisJobs@gmail.com",
                receivers=self.email_to,
                html=html,
            )
            logging.info(f"Email sent successfully to {self.email_to}")
        except Exception as e:
            logging.error(f"Email sending to {self.email_to} failed: {e}")
            raise e
