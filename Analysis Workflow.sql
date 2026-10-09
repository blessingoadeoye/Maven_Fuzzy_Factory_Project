/* ============================================================
   MAVEN FUZZY FACTORY — WEBSITE PERFORMANCE ANALYSIS
   ============================================================

   This analysis observes the company's marketing channel
   performance, website conversion performance, and the impact
   of introducing new products over time.
*/


/* ============================================================
   Q1. COMPANY GROWTH VOLUME
   ============================================================

   Determine the company's growth volume by reviewing the
   overall website sessions and orders on a quarterly basis.
*/

SELECT
    YEAR(website_sessions.created_at) AS year,
    QUARTER(website_sessions.created_at) AS quarter,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders
FROM website_sessions
LEFT JOIN orders
    ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2015-01-01'
GROUP BY
    YEAR(website_sessions.created_at),
    QUARTER(website_sessions.created_at);


/*
   FINDING:
   The quarterly review shows an overall increase in both
   website sessions and orders over the analysis period.

   The growth becomes noticeable, particularly toward the
   later quarters, with Q4 recording the highest activity
   in each complete year.
*/



/* ============================================================
   Q2. WEBSITE EFFICIENCY IMPROVEMENTS
   ============================================================

   Demonstrate the website's efficiency improvements since
   launch by reviewing the following quarterly metrics:

   i.   Session-to-order conversion rate
   ii.  Revenue per order
   iii. Revenue per session
*/

SELECT
    YEAR(website_sessions.created_at) AS year,
    QUARTER(website_sessions.created_at) AS quarter,
    COUNT(DISTINCT orders.order_id)
        / COUNT(DISTINCT website_sessions.website_session_id)
        AS session_to_order_conversion_rate,
    SUM(orders.price_usd)
        / COUNT(DISTINCT orders.order_id)
        AS revenue_per_order,
    SUM(orders.price_usd)
        / COUNT(DISTINCT website_sessions.website_session_id)
        AS revenue_per_session
FROM website_sessions
LEFT JOIN orders
    ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2015-01-01'
GROUP BY
    YEAR(website_sessions.created_at),
    QUARTER(website_sessions.created_at);


/*
   FINDING:
   The quarterly review shows an overall improvement in the
   website's ability to convert sessions into orders.

   Revenue per order and revenue per session also increased
   over time, showing that the growth was not limited to
   only the website traffic.
*/



/* ============================================================
   Q3. TRAFFIC CHANNEL ORDER VOLUME
   ============================================================

   Showcase the traffic generated through the major channels
   by pulling the quarterly order trend for:

   i.   Gsearch nonbrand
   ii.  Bsearch nonbrand
   iii. Gsearch/Bsearch brand
   iv.  Organic search
   v.   Direct type-in
*/

SELECT
    YEAR(website_sessions.created_at) AS year,
    QUARTER(website_sessions.created_at) AS quarter,

    COUNT(DISTINCT CASE
        WHEN utm_source = 'gsearch'
            AND utm_campaign = 'nonbrand'
        THEN order_id
    END) AS gsearch_nonbrand,

    COUNT(DISTINCT CASE
        WHEN utm_source = 'bsearch'
            AND utm_campaign = 'nonbrand'
        THEN order_id
    END) AS bsearch_nonbrand,

    COUNT(DISTINCT CASE
        WHEN utm_source IN ('gsearch', 'bsearch')
            AND utm_campaign = 'brand'
        THEN order_id
    END) AS brand_search,

    COUNT(DISTINCT CASE
        WHEN utm_source IS NULL
            AND http_referer IN (
                'https://www.gsearch.com',
                'https://www.bsearch.com'
            )
        THEN order_id
    END) AS organic_search,

    COUNT(DISTINCT CASE
        WHEN utm_source IS NULL
            AND http_referer IS NULL
        THEN order_id
    END) AS direct_type_in

FROM website_sessions
LEFT JOIN orders
    ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2015-01-01'
GROUP BY
    YEAR(website_sessions.created_at),
    QUARTER(website_sessions.created_at);


/*
   FINDING:
   Gsearch nonbrand generated the largest order volume among
   the reviewed channels throughout the analysis period.

   Brand search, organic search, and direct type-in also
   developed over time, showing that order activity was not
   limited to nonbrand paid traffic alone.
*/



/* ============================================================
   Q4. TRAFFIC CHANNEL CONVERSION EFFICIENCY
   ============================================================

   Present the quarterly session-to-order conversion rate
   for the same traffic channels reviewed above.

   This provides a view of channel efficiency alongside
   the order volumes observed in Q3.
*/

SELECT
    YEAR(website_sessions.created_at) AS year,
    QUARTER(website_sessions.created_at) AS quarter,

    COUNT(DISTINCT CASE
        WHEN utm_source = 'gsearch'
            AND utm_campaign = 'nonbrand'
        THEN order_id
    END)
    /
    COUNT(DISTINCT CASE
        WHEN utm_source = 'gsearch'
            AND utm_campaign = 'nonbrand'
        THEN website_sessions.website_session_id
    END) AS gsearch_nonbrand_conversion_rate,

    COUNT(DISTINCT CASE
        WHEN utm_source = 'bsearch'
            AND utm_campaign = 'nonbrand'
        THEN order_id
    END)
    /
    COUNT(DISTINCT CASE
        WHEN utm_source = 'bsearch'
            AND utm_campaign = 'nonbrand'
        THEN website_sessions.website_session_id
    END) AS bsearch_nonbrand_conversion_rate,

    COUNT(DISTINCT CASE
        WHEN utm_source IN ('gsearch', 'bsearch')
            AND utm_campaign = 'brand'
        THEN order_id
    END)
    /
    COUNT(DISTINCT CASE
        WHEN utm_source IN ('gsearch', 'bsearch')
            AND utm_campaign = 'brand'
        THEN website_sessions.website_session_id
    END) AS brand_search_conversion_rate,

    COUNT(DISTINCT CASE
        WHEN utm_source IS NULL
            AND http_referer IN (
                'https://www.gsearch.com',
                'https://www.bsearch.com'
            )
        THEN order_id
    END)
    /
    COUNT(DISTINCT CASE
        WHEN utm_source IS NULL
            AND http_referer IN (
                'https://www.gsearch.com',
                'https://www.bsearch.com'
            )
        THEN website_sessions.website_session_id
    END) AS organic_search_conversion_rate,

    COUNT(DISTINCT CASE
        WHEN utm_source IS NULL
            AND http_referer IS NULL
        THEN order_id
    END)
    /
    COUNT(DISTINCT CASE
        WHEN utm_source IS NULL
            AND http_referer IS NULL
        THEN website_sessions.website_session_id
    END) AS direct_type_in_conversion_rate

FROM website_sessions
LEFT JOIN orders
    ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2015-01-01'
GROUP BY
    YEAR(website_sessions.created_at),
    QUARTER(website_sessions.created_at);


/*
   FINDING:
   Conversion rates generally improved across the reviewed
   channels over time.

   This adds another view to Q3: order volume shows how much
   business each channel generated, while conversion rate
   shows how efficiently its sessions resulted in orders.
*/



/* ============================================================
   Q5. GSEARCH LANDING-PAGE TEST
   ============================================================

   Estimate the impact of the Gsearch landing-page test
   between '/home' and '/lander-1'.

   The test is limited to Gsearch nonbrand sessions between
   '2012-06-19' and '2012-07-28'.

   The process is to:

   i.   Identify the first pageview for each test session.
   ii.  Determine whether the session landed on '/home'
        or '/lander-1'.
   iii. Link the sessions to orders.
   iv.  Compare the session-to-order conversion rates.
*/


-- i. Identify the first pageview for each test session.

CREATE TEMPORARY TABLE landertest_firstpageview AS
SELECT
    website_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_pageview
FROM website_pageviews
INNER JOIN website_sessions
    ON website_sessions.website_session_id =
       website_pageviews.website_session_id
    AND website_sessions.created_at
        BETWEEN '2012-06-19' AND '2012-07-28'
    AND website_sessions.utm_source = 'gsearch'
    AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY
    website_pageviews.website_session_id;


-- ii. Identify whether the first page was '/home'
--     or '/lander-1'.

CREATE TEMPORARY TABLE landertest_landingpage AS
SELECT
    landertest_firstpageview.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM landertest_firstpageview
LEFT JOIN website_pageviews
    ON landertest_firstpageview.min_pageview =
       website_pageviews.website_pageview_id
WHERE website_pageviews.pageview_url IN ('/home', '/lander-1');


-- iii. Link each landing-page session to its order.

CREATE TEMPORARY TABLE landertest_page_with_orders AS
SELECT
    landertest_landingpage.website_session_id,
    landertest_landingpage.landing_page,
    orders.order_id
FROM landertest_landingpage
LEFT JOIN orders
    ON orders.website_session_id =
       landertest_landingpage.website_session_id;


-- iv. Compare the conversion rate for both landing pages.

SELECT
    landing_page,
    COUNT(DISTINCT website_session_id) AS total_sessions,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT order_id)
        / COUNT(DISTINCT website_session_id)
        AS conversion_rate
FROM landertest_page_with_orders
GROUP BY
    landing_page;


/*
   FINDING:
   '/lander-1' recorded the stronger session-to-order
   conversion rate during the test period.

   '/home' converted about 3.18% of sessions, while
   '/lander-1' converted about 4.06%.

   This represents an absolute conversion-rate lift of
   approximately 0.88 percentage points.
*/


/* ------------------------------------------------------------
   ESTIMATING THE INCREMENTAL ORDERS
   ------------------------------------------------------------

   Next, determine the last Gsearch nonbrand session that
   landed on '/home'. This provides the point after which
   '/lander-1' had taken over for these sessions.
*/

SELECT
    MAX(website_sessions.website_session_id) AS last_home_session_id
FROM website_sessions
LEFT JOIN website_pageviews
    ON website_sessions.website_session_id =
       website_pageviews.website_session_id
WHERE website_pageviews.pageview_url = '/home'
    AND website_sessions.utm_source = 'gsearch'
    AND website_sessions.utm_campaign = 'nonbrand'
    AND website_sessions.created_at < '2012-11-27';


-- The original analysis returned session_id 17145.
-- Use this point to count the later Gsearch nonbrand sessions.

SELECT
    COUNT(DISTINCT website_session_id) AS new_page_sessions
FROM website_sessions
WHERE created_at < '2012-11-27'
    AND website_session_id > 17145
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand';


/*
   FINDING:
   The original analysis returned 22,972 subsequent
   Gsearch nonbrand sessions.

   Applying the approximate 0.87 percentage-point lift used
   in the original calculation:

       22,972 x 0.0087 ≈ 200

   This gives an estimate of about 200 incremental orders
   after the stronger landing page was introduced.
*/



/* ============================================================
   Q6. FULL LANDING-PAGE CONVERSION FUNNEL
   ============================================================

   From the previous '/home' to '/lander-1' test, build a
   full conversion funnel from both landing pages through
   to completed orders.

   The analysis uses the same test period:
   '2012-06-19' to '2012-07-28'.
*/


-- i. Flag the pages visited within each Gsearch nonbrand
--    session during the test period.

CREATE TEMPORARY TABLE pageview_level AS
SELECT
    website_sessions.website_session_id,
    website_pageviews.pageview_url,

    CASE
        WHEN website_pageviews.pageview_url = '/home'
        THEN 1 ELSE 0
    END AS home_page,

    CASE
        WHEN website_pageviews.pageview_url = '/lander-1'
        THEN 1 ELSE 0
    END AS lander_page,

    CASE
        WHEN website_pageviews.pageview_url = '/products'
        THEN 1 ELSE 0
    END AS products_page,

    CASE
        WHEN website_pageviews.pageview_url =
             '/the-original-mr-fuzzy'
        THEN 1 ELSE 0
    END AS mr_fuzzy_page,

    CASE
        WHEN website_pageviews.pageview_url = '/cart'
        THEN 1 ELSE 0
    END AS cart_page,

    CASE
        WHEN website_pageviews.pageview_url = '/shipping'
        THEN 1 ELSE 0
    END AS shipping_page,

    CASE
        WHEN website_pageviews.pageview_url = '/billing'
        THEN 1 ELSE 0
    END AS billing_page,

    CASE
        WHEN website_pageviews.pageview_url =
             '/thank-you-for-your-order'
        THEN 1 ELSE 0
    END AS thank_you_page

FROM website_sessions
LEFT JOIN website_pageviews
    ON website_sessions.website_session_id =
       website_pageviews.website_session_id
WHERE website_sessions.utm_source = 'gsearch'
    AND website_sessions.utm_campaign = 'nonbrand'
    AND website_sessions.created_at
        BETWEEN '2012-06-19' AND '2012-07-28'
ORDER BY
    website_sessions.website_session_id,
    website_pageviews.created_at;


-- ii. Summarize the pageview flags at session level.

CREATE TEMPORARY TABLE session_level_made_it AS
SELECT
    website_session_id,
    MAX(home_page) AS seen_home,
    MAX(lander_page) AS seen_lander,
    MAX(products_page) AS seen_products,
    MAX(mr_fuzzy_page) AS seen_mr_fuzzy,
    MAX(cart_page) AS seen_cart,
    MAX(shipping_page) AS seen_shipping,
    MAX(billing_page) AS seen_billing,
    MAX(thank_you_page) AS seen_thank_you
FROM pageview_level
GROUP BY
    website_session_id;


-- iii. Compare the number of sessions reaching each stage
--      of the funnel from the two landing pages.
--
--      Reuse the landing-page classification established
--      in Q5 so each session is grouped by the page on
--      which it actually entered the test.

CREATE TEMPORARY TABLE from_lander_to AS
SELECT
    landertest_landingpage.landing_page AS segment,

    COUNT(DISTINCT session_level_made_it.website_session_id)
        AS sessions,

    COUNT(DISTINCT CASE
        WHEN seen_products = 1
        THEN session_level_made_it.website_session_id
    END) AS to_products,

    COUNT(DISTINCT CASE
        WHEN seen_mr_fuzzy = 1
        THEN session_level_made_it.website_session_id
    END) AS to_mr_fuzzy,

    COUNT(DISTINCT CASE
        WHEN seen_cart = 1
        THEN session_level_made_it.website_session_id
    END) AS to_cart,

    COUNT(DISTINCT CASE
        WHEN seen_shipping = 1
        THEN session_level_made_it.website_session_id
    END) AS to_shipping,

    COUNT(DISTINCT CASE
        WHEN seen_billing = 1
        THEN session_level_made_it.website_session_id
    END) AS to_billing,

    COUNT(DISTINCT CASE
        WHEN seen_thank_you = 1
        THEN session_level_made_it.website_session_id
    END) AS to_thank_you

FROM session_level_made_it
INNER JOIN landertest_landingpage
    ON session_level_made_it.website_session_id =
       landertest_landingpage.website_session_id
GROUP BY
    landertest_landingpage.landing_page;


-- iv. Calculate the conversion rate between each stage
--     of the funnel for both landing pages.

SELECT
    landertest_landingpage.landing_page AS segment,

    COUNT(DISTINCT session_level_made_it.website_session_id)
        AS sessions,

    COUNT(DISTINCT CASE
        WHEN seen_products = 1
        THEN session_level_made_it.website_session_id
    END)
    / COUNT(DISTINCT session_level_made_it.website_session_id)
        AS products_click_rate,

    COUNT(DISTINCT CASE
        WHEN seen_mr_fuzzy = 1
        THEN session_level_made_it.website_session_id
    END)
    / COUNT(DISTINCT CASE
        WHEN seen_products = 1
        THEN session_level_made_it.website_session_id
    END) AS mr_fuzzy_click_rate,

    COUNT(DISTINCT CASE
        WHEN seen_cart = 1
        THEN session_level_made_it.website_session_id
    END)
    / COUNT(DISTINCT CASE
        WHEN seen_mr_fuzzy = 1
        THEN session_level_made_it.website_session_id
    END) AS cart_click_rate,

    COUNT(DISTINCT CASE
        WHEN seen_shipping = 1
        THEN session_level_made_it.website_session_id
    END)
    / COUNT(DISTINCT CASE
        WHEN seen_cart = 1
        THEN session_level_made_it.website_session_id
    END) AS shipping_click_rate,

    COUNT(DISTINCT CASE
        WHEN seen_billing = 1
        THEN session_level_made_it.website_session_id
    END)
    / COUNT(DISTINCT CASE
        WHEN seen_shipping = 1
        THEN session_level_made_it.website_session_id
    END) AS billing_click_rate,

    COUNT(DISTINCT CASE
        WHEN seen_thank_you = 1
        THEN session_level_made_it.website_session_id
    END)
    / COUNT(DISTINCT CASE
        WHEN seen_billing = 1
        THEN session_level_made_it.website_session_id
    END) AS thank_you_click_rate

FROM session_level_made_it
INNER JOIN landertest_landingpage
    ON session_level_made_it.website_session_id =
       landertest_landingpage.website_session_id
GROUP BY
    landertest_landingpage.landing_page;


/*
   FINDING:
   The funnel shows differences between the two landing
   pages at several stages of the customer journey.

   '/lander-1' produced a higher click-through rate to the
   products page and a higher final billing-to-order
   completion rate than '/home'.

   Not every individual funnel step was higher for
   '/lander-1', so the result is better described as an
   overall improvement rather than an improvement at
   every single stage.
*/



/* ============================================================
   Q7. IMPACT OF INTRODUCING NEW PRODUCTS
   ============================================================

   The company began with a single product and introduced
   additional products over time.

   Compare the yearly sales, revenue, and margin from the
   first primary product with the overall product results
   to observe how performance developed as the product
   offering expanded.
*/


-- Performance from orders where Product 1 was the
-- primary product.

SELECT
    YEAR(created_at) AS year,
    COUNT(DISTINCT order_id) AS total_sales,
    SUM(price_usd) AS total_revenue,
    SUM(price_usd - cogs_usd) AS margin
FROM orders
WHERE primary_product_id = 1
    AND created_at < '2015-01-01'
GROUP BY
    YEAR(created_at);


-- Performance across all primary products.

SELECT
    YEAR(created_at) AS year,
    COUNT(DISTINCT order_id) AS total_sales,
    SUM(price_usd) AS total_revenue,
    SUM(price_usd - cogs_usd) AS margin
FROM orders
WHERE created_at < '2015-01-01'
GROUP BY
    YEAR(created_at);


/*
   FINDING:
   Sales, revenue, and margin increased as the business
   expanded beyond its first product.

   The difference between the first-product results and
   the overall results becomes more noticeable in 2013
   and 2014 as additional products contribute to the
   company's performance.
*/



/* ============================================================
   Q8. PRODUCTS PAGE PERFORMANCE OVER TIME
   ============================================================

   Dive deeper into the impact of introducing new products
   by reviewing, monthly:

   i.   Sessions reaching the '/products' page.
   ii.  The percentage of those sessions clicking through
        to another page.
   iii. The percentage of those sessions resulting in
        an order.

   This analysis follows the available products-page
   activity through March 2015.
*/


-- i. Identify sessions reaching the '/products' page.

CREATE TEMPORARY TABLE pageview_session_basics AS
SELECT
    YEAR(created_at) AS year,
    MONTH(created_at) AS month,
    website_session_id AS products_page_session,
    website_pageview_id AS products_pageview_id
FROM website_pageviews
WHERE pageview_url = '/products';


-- ii. Identify the next pageview after the '/products'
--     page for each session.

CREATE TEMPORARY TABLE product_vs_next_page AS
SELECT
    pageview_session_basics.year,
    pageview_session_basics.month,
    pageview_session_basics.products_page_session,
    pageview_session_basics.products_pageview_id,
    MIN(website_pageviews.website_pageview_id)
        AS page_after_products
FROM pageview_session_basics
LEFT JOIN website_pageviews
    ON pageview_session_basics.products_page_session =
       website_pageviews.website_session_id
    AND website_pageviews.website_pageview_id >
        pageview_session_basics.products_pageview_id
GROUP BY
    pageview_session_basics.year,
    pageview_session_basics.month,
    pageview_session_basics.products_page_session,
    pageview_session_basics.products_pageview_id;


-- iii. Aggregate the monthly products-page activity.

SELECT
    product_vs_next_page.year,
    product_vs_next_page.month,

    COUNT(DISTINCT products_page_session)
        AS sessions_to_products,

    COUNT(DISTINCT page_after_products)
        AS clicked_through_products,

    COUNT(DISTINCT page_after_products)
        / COUNT(DISTINCT products_page_session)
        AS clicked_through_products_rate,

    COUNT(DISTINCT orders.order_id)
        AS orders_from_products,

    COUNT(DISTINCT orders.order_id)
        / COUNT(DISTINCT products_page_session)
        AS orders_from_products_rate

FROM product_vs_next_page
LEFT JOIN orders
    ON product_vs_next_page.products_page_session =
       orders.website_session_id
GROUP BY
    product_vs_next_page.year,
    product_vs_next_page.month;


/*
   FINDING:
   The '/products' page attracted substantially more
   sessions over time.

   The percentage of sessions clicking through from the
   products page also generally improved, while the share
   of products-page sessions resulting in orders became
   stronger compared with the earlier periods.

   This supports the broader observation that website
   activity developed alongside the expansion of the
   company's product offering.
*/



/* ============================================================
   Q9. PRODUCT CROSS-SELL PERFORMANCE
   ============================================================

   Product 4 was introduced as a primary product on
   December 5, 2014, after previously being available
   as a cross-sell product.

   Review sales from the introduction date to determine
   how frequently each primary product was purchased
   alongside the other products.
*/

SELECT
    orders.primary_product_id,

    COUNT(DISTINCT CASE
        WHEN order_items.product_id = 1
        THEN orders.order_id
    END) AS cross_sell_product_1,

    COUNT(DISTINCT CASE
        WHEN order_items.product_id = 2
        THEN orders.order_id
    END) AS cross_sell_product_2,

    COUNT(DISTINCT CASE
        WHEN order_items.product_id = 3
        THEN orders.order_id
    END) AS cross_sell_product_3,

    COUNT(DISTINCT CASE
        WHEN order_items.product_id = 4
        THEN orders.order_id
    END) AS cross_sell_product_4,

    COUNT(DISTINCT CASE
        WHEN order_items.product_id = 1
        THEN orders.order_id
    END)
    / COUNT(DISTINCT orders.order_id)
        AS cross_sell_product_1_rate,

    COUNT(DISTINCT CASE
        WHEN order_items.product_id = 2
        THEN orders.order_id
    END)
    / COUNT(DISTINCT orders.order_id)
        AS cross_sell_product_2_rate,

    COUNT(DISTINCT CASE
        WHEN order_items.product_id = 3
        THEN orders.order_id
    END)
    / COUNT(DISTINCT orders.order_id)
        AS cross_sell_product_3_rate,

    COUNT(DISTINCT CASE
        WHEN order_items.product_id = 4
        THEN orders.order_id
    END)
    / COUNT(DISTINCT orders.order_id)
        AS cross_sell_product_4_rate

FROM orders
LEFT JOIN order_items
    ON orders.order_id = order_items.order_id
    AND order_items.is_primary_item = 0
WHERE orders.created_at
    BETWEEN '2014-12-05' AND '2015-03-20'
GROUP BY
    orders.primary_product_id
ORDER BY
    orders.primary_product_id;


/*
   FINDING:
   The cross-sell analysis shows that customers purchasing
   a primary product also added other products to some
   orders.

   Product 4 recorded the strongest cross-sell rate for
   orders where Products 1, 2, or 3 were the primary
   product during the reviewed period.

   This shows an additional way the wider product range
   contributed to orders beyond primary-product sales.
*/



/* ============================================================
   OVERALL CONCLUSION
   ============================================================

   1. The business recorded overall growth in website
      sessions and orders across the analysis period, with
      particularly strong activity toward the later
      quarters of each year.

   2. Website efficiency also improved over time. The
      session-to-order conversion rate and revenue per
      session generally increased alongside traffic growth.

   3. Gsearch nonbrand remained the largest source of
      orders among the reviewed channels, while brand,
      organic, and direct traffic also developed as the
      business grew.

   4. The '/lander-1' test produced a stronger overall
      conversion result than the original '/home' page.
      Applying the observed lift to later Gsearch nonbrand
      traffic gave an estimate of about 200 incremental
      orders.

   5. The introduction of additional products coincided
      with stronger overall sales, revenue, and margin.
      The wider product range also created opportunities
      for cross-selling within individual orders.
*/
