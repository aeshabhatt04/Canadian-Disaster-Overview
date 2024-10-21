# Canadian-Disaster-Overview

This project focused on analyzing disaster-related data from Canada, sourced from the Public Safety Canada website. It utilized PostgreSQL and pgAdmin to load, clean, transform, and analyze the data. Visualizations were created using Excel to derive meaningful insights. Here's a detailed overview of the process:

### Project Overview:
The dataset covered various disaster events in Canada over a decade and was divided into four main tables:
1. **Events**: Contains details about the types of disasters (e.g., floods, terrorist attacks, etc.).
2. **Casualties**: Includes information on the number of people affected, fatalities, estimated and normalized costs.
3. **Location**: Specifies where and when the disasters occurred.
4. **Relief Aid**: Details financial aid provided by the federal and provincial governments and insurance companies.

### Key Steps:
1. **Data Acquisition & Loading**:
   - The data was sourced from a live feed on the Canadian government website.
   - It was loaded into PostgreSQL using pgAdmin, with tables created for events, casualties, locations, and relief aid.
   
2. **Data Cleaning & Transformation**:
   - Null values, duplicates, and unnecessary spaces were removed.
   - The data was structured and transformed, splitting it into relevant tables (events, casualties, locations, and relief aid).
   - Foreign keys were established to ensure referential integrity between tables.

3. **Data Analysis**:
   SQL queries were written to extract insights about disasters, focusing on areas such as:
   - **Frequency of Disasters**: Identified "Meteorological-Hydrological" disasters as the most common (e.g., floods).
   - **Impact Assessment**: Analyzed the number of affected individuals and fatalities for different types of disasters. For example, pandemics had the highest impact in terms of affected people, while winter storms had notable fatalities.
   - **Cost Analysis**: Disasters were grouped by their economic impact, with floods and winter storms showing significant financial damage.
   - **Geographical Insights**: Regions like the Prairie Provinces were frequently hit by droughts, while other areas like Alberta faced frequent storms.

4. **Visualization in Excel**:
   - Created visuals, such as treemaps and pie charts, to help decision-makers understand the frequency and impact of various disaster types.
   - A scatter plot illustrated the weak correlation between disaster size and financial aid provided, highlighting areas where relief efforts could be improved.
   - Bar charts showed the top disaster types and their associated costs, with detailed breakdowns for each region.

### Results:
- **Key Insights**: 
   - Meteorological events, especially floods, were the most frequent, while pandemics had the largest impact on the population.
   - The economic burden varied widely, with some disasters like winter storms incurring higher costs despite lower fatality counts.
   - Visualizations offered clear comparisons for resource allocation and preparedness, helping guide strategic planning for future disaster responses.

This project combined advanced SQL techniques with data visualization, producing actionable insights for disaster management in Canada.
