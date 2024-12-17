import requests
import pandas as pd
from bs4 import BeautifulSoup
from datetime import datetime, timedelta
from helper import Email, config


def convert_date_format(data_value):
    try:
        # Try to parse the date with the expected format
        date_obj = datetime.strptime(data_value, "%d-%m-%Y")
        # Convert it to the desired format
        return date_obj.strftime("%Y-%m-%d")
    except ValueError:
        # If parsing fails, just return the original value
        return data_value


MAIN_URL = "https://scri.uniri.hr"
OLDEST_DATE = (datetime.now() - timedelta(days=2)).strftime("%Y-%m-%d")
COLS_TO_EXCLUDE = [
    "završetak_rada",
    "poštanski_broj",
    "sanitarna_knjižica",
    "vrsta_posla",
    "posted",
    "objavi_od",
    "objavi_do",
]

control_panel_url = f"{MAIN_URL}/student-servis/jobseeker-control-panel"
control_panel_response = requests.get(
    control_panel_url, headers={"User-Agent": "Mozilla/5.0"}
)
control_panel_response.raise_for_status()
control_panel_soup = BeautifulSoup(control_panel_response.text, "html5lib")

data = []
for a in control_panel_soup.find_all("a", class_="jobtitle"):
    job_dict = {}
    job_url = MAIN_URL + a["href"]

    job_response = requests.get(job_url, headers={"User-Agent": "Mozilla/5.0"})
    job_response.raise_for_status()
    job_response_soup = BeautifulSoup(job_response.text, "html5lib")

    job_dict["url"] = job_url

    title = job_response_soup.find("span", class_="jsjobs-main-page-title")
    job_dict["naziv_pozicije"] = title.text.strip()

    for i, key_val in enumerate(["napomene_i_uvjeti", "kompetencije", "kontakt"]):
        addition_info_response = job_response_soup.find_all(
            "div", class_="jsjobs_full_width_data"
        )[i].find("p")
        try:
            job_dict[key_val] = addition_info_response.text.strip()
        except:
            job_dict[key_val] = None

    for column_div in job_response_soup.find_all("div", class_="js_job_data_wrapper"):
        data_key = column_div.find("span", class_="js_job_data_title")
        data_key = data_key.text.split(":")[0].strip().lower().replace(" ", "_")

        data_value = column_div.find("span", class_="js_job_data_value")
        data_value = convert_date_format(data_value.text.strip().replace(" €", ""))

        job_dict[data_key] = data_value

    if job_dict["posted"] <= OLDEST_DATE:
        break

    data.append(job_dict)

df = pd.DataFrame(data)
if df.empty:
    raise ValueError("DataFrame is empty, cannot proceed with processing.")

df.drop(columns=COLS_TO_EXCLUDE, inplace=True)

html = df.to_html(render_links=True, escape=False)

email = Email(email_to=config["targetEmails"])
email.send_email(html=html)
