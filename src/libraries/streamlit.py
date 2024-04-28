import streamlit as st
import pandas as pd
import altair as alt
from snowflake.snowpark.context import get_active_session
from snowflake.snowpark.functions import count_distinct,col,sum
import snowflake.permissions as permission
from sys import exit
from PIL import Image


st.set_page_config(layout="wide")
session = get_active_session()


def main():
    # Display the logo
    logo_path = "./logo.png"
    logo = Image.open(logo_path)
    # Check if the image has an alpha channel (transparency)
    # if logo.mode in ("RGBA", "LA") or (logo.mode == "P" and 'transparency' in logo.info):
    #     # Create a white background image
    #     white_bg = Image.new("RGBA", logo.size, "WHITE")
    #     # Paste the logo on top of the white background
    #     white_bg.paste(logo, (0, 0), logo)
    #     logo = white_bg.convert('RGB')
    # st.image(logo, width=300)  # Adjust the width as needed
    st.header("INNOVA Q")
    # Display the main welcome message
    st.title("Welcome to the One-Stop Location for All Your Compliance Needs!")

    # Display the sub-message
    st.subheader("Please navigate to the respective plants in the sidebar.")


main()