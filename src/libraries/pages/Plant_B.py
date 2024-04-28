import streamlit as st
import altair as alt
import pandas as pd
import datetime
from snowflake.snowpark.context import get_active_session
from snowflake.snowpark.functions import count_distinct,col,sum
import snowflake.permissions as permission

st.header("PLANT B")
 
session = get_active_session()

st.sidebar.success("Plant Status : Active")




# Perform query.
env_monitoring = session.sql("SELECT * from ENV_MONITORING;").to_pandas()
equipment_audit = session.sql("SELECT * from EQUIPMENT_AUDIT;").to_pandas()
fsq_misses = session.sql("SELECT * from FSQ_MISSES;").to_pandas()
internal_audit = session.sql("SELECT * from INTERNAL_AUDIT;").to_pandas()
pc_ccp_deviation = session.sql("SELECT * from PC_CCP_DEVIATION;").to_pandas()
supplied_material = session.sql("SELECT * from SUPPLIED_MATERIAL_QUALITY;").to_pandas()
sanitation = session.sql("SELECT * from SANITATION;").to_pandas()
supplier_performance = session.sql("SELECT * from SUPPLIER_PERFORMANCE;").to_pandas()


option = st.selectbox("Select an KPI : " , ["ENV_MONITORING" , "EQUIPMENT_AUDIT" , "FSQ_MISSES" , "INTERNAL_AUDIT" , "PC_CCP_DEVIATION",
                                            "SUPPLIED_MATERIAL_QUALITY" , "SANITATION" ,"SUPPLIER_PERFORMANCE" ])

if option == "ENV_MONITORING":
    env_monitoring['DATE'] = pd.to_datetime(env_monitoring['DATE'])
    data = env_monitoring
    data['DATE'] = data['DATE'].dt.date
    min_date = data["DATE"].min()
    max_date = data["DATE"].max()
    date_range = st.slider(
        "Select Date Range",
        min_value=min_date,
        max_value=max_date,
        value=(min_date, max_date)  # Default to full range
    )
    filtered_data = data[(data["DATE"]>= date_range[0])&(data["DATE"] <= date_range[1])]

    chart = alt.Chart(filtered_data).mark_line().encode(
        x=alt.X('DATE:T', title='Date'),
        y=alt.Y('MONITORING_VALUE:Q', title='Monitoring Value')
    ).properties(
        title='Environmental Monitoring Data Over Time',
        width = 800,
        height=400
    )
    rule = alt.Chart(pd.DataFrame({'y': [20]})).mark_rule(color='red', strokeWidth=2).encode(
        y='y:Q'
    )
    final_chart = chart+rule

    st.altair_chart(final_chart)
    

    
elif option=="EQUIPMENT_AUDIT":
    st.markdown(f"# Make a chart for {option}")
    equipment_audit['DATE'] = pd.to_datetime(equipment_audit['DATE'])
    data = equipment_audit
    data['DATE'] = data['DATE'].dt.date
    min_date = data["DATE"].min()
    max_date = data["DATE"].max()
    date_range = st.slider(
        "Select Date Range",
        min_value=min_date,
        max_value=max_date,
        value=(min_date, max_date)  # Default to full range
    )
    filtered_data = data[(data["DATE"]>= date_range[0])&(data["DATE"] <= date_range[1])]
    filtered_data['DATE'] = pd.to_datetime(filtered_data['DATE'])
    filtered_data['WEEK_START'] = filtered_data['DATE'] - pd.to_timedelta(filtered_data['DATE'].dt.weekday, unit='D')
    

    # Create the bar chart for audit results summarized by the recalculated start of each week
    chart = alt.Chart(filtered_data).mark_bar().encode(
        x=alt.X('WEEK_START:T', title='Week Starting', axis=alt.Axis(format='%Y-%m-%d')),
        y=alt.Y('count()', title='Number of Audits'),
        color='AUDIT_RESULT:N',
        tooltip=[alt.Tooltip('WEEK_START:T', title='Week Starting', format='%Y-%m-%d'), 'AUDIT_RESULT', 'count()']
    ).properties(
        title='Equipment Audit Results Over Time, Aggregated by Week Starting',
        width=800,
        height=400
    )

    # Display the chart
    st.altair_chart(chart)

elif option == "FSQ_MISSES":
    st.markdown(f"# Make a chart for {option}")
    fsq_misses['DATE'] = pd.to_datetime(fsq_misses['DATE'])
    data = fsq_misses
    data['DATE'] = data['DATE'].dt.date
    min_date = data["DATE"].min()
    max_date = data["DATE"].max()
    date_range = st.slider(
        "Select Date Range",
        min_value=min_date,
        max_value=max_date,
        value=(min_date, max_date)  # Default to full range
    )
    filtered_data = data[(data["DATE"]>= date_range[0])&(data["DATE"] <= date_range[1])]

   # Create the stacked area chart for FSQ misses data summarized by week
    chart = alt.Chart(filtered_data).mark_area().encode(
        x=alt.X('yearmonthdate(DATE):T', title='Week', timeUnit='week'),
        y=alt.Y('sum(MISSES):Q', title='Total Incidents', stack='zero'),
        color=alt.Color('key:N', legend=alt.Legend(title="Incident Types")),
        tooltip=[alt.Tooltip('yearmonthdate(DATE):T', title='Week', timeUnit='week'), alt.Tooltip('sum(MISSES):Q', title='MISSES'),
                alt.Tooltip('sum(WITHDRAWALS):Q', title='WITHDRAWALS'), alt.Tooltip('sum(RECALLS):Q', title='RECALLS')]
    ).transform_fold(
        fold=['MISSES', 'WITHDRAWALS', 'RECALLS'],
        as_=['key', 'value']
    ).properties(
        title='FSQ Misses, Withdrawals, and Recalls Over Time, Aggregated by Week',
        width=800,
        height=400
    )

    # Display the chart
    st.altair_chart(chart)
elif option=="INTERNAL_AUDIT":
    st.markdown(f"# Make a chart for {option}")
    internal_audit['DATE'] = pd.to_datetime(internal_audit['DATE'])
    data = internal_audit
    data['DATE'] = data['DATE'].dt.date
    
    # Define your minimum and maximum date for the slider
    min_date = data['DATE'].min()
    max_date = data['DATE'].max()

    # Creating a slider for selecting a date range
    date_range = st.slider(
        "Select Date Range",
        min_value=min_date,
        max_value=max_date,
        value=(min_date, max_date)  # Default to full range
    )
    # Filter the data based on the slider's output
    filtered_data = data[(data['DATE'] >= date_range[0]) & (data['DATE'] <= date_range[1])]
    filtered_data['DATE'] = pd.to_datetime(filtered_data['DATE'])

    # Recalculate 'WEEK_START' for the filtered data
    filtered_data['WEEK_START'] = filtered_data['DATE'] - pd.to_timedelta(filtered_data['DATE'].dt.weekday, unit='D')

    # Create the bar chart for audit results summarized by the recalculated start of each week
    chart = alt.Chart(filtered_data).mark_bar().encode(
        x=alt.X('WEEK_START:T', title='Week Starting', axis=alt.Axis(format='%Y-%m-%d')),
        y=alt.Y('count()', title='Number of Audits'),
        color='AUDIT_RESULT:N',
        tooltip=[alt.Tooltip('WEEK_START:T', title='Week Starting', format='%Y-%m-%d'), 'AUDIT_RESULT', 'count()']
    ).properties(
        title='Internal Audit Results Over Time, Aggregated by Week Starting',
        width=800,
        height=400
    )

    # Display the chart
    st.altair_chart(chart)
else:
    st.markdown(f"#### Chart for {option} coming soon...")

    





# create or replace view app_instance_schema.ENV_MONITORING as select * from shared_content_schema.MFG_SHIPPING;
# create or replace view app_instance_schema.EQUIPMENT_AUDIT as select * from shared_content_schema.MFG_SHIPPING;
# create or replace view app_instance_schema.FSQ_MISSES as select * from shared_content_schema.MFG_SHIPPING;
# create or replace view app_instance_schema.INTERNAL_AUDIT as select * from shared_content_schema.MFG_SHIPPING;
# create or replace view app_instance_schema.PC_CCP_DEVIATION as select * from shared_content_schema.MFG_SHIPPING;
# create or replace view app_instance_schema.SUPPLIED_MATERIAL_QUALITY as select * from shared_content_schema.MFG_SHIPPING;
# create or replace view app_instance_schema.SANITATION as select * from shared_content_schema.MFG_SHIPPING;
# create or replace view app_instance_schema.SUPPLIER_PERFORMANCE as select * from shared_content_schema.MFG_SHIPPING;