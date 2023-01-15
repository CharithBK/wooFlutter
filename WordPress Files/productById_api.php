<?php

/*
Template Name: productbyId
*/

class ProductById extends WC_REST_Products_V1_Controller
{
    
    public function categories_data($id)
    {
        $terms = get_the_terms($id, 'product_cat');
        
        $terms = json_encode($terms, JSON_PRETTY_PRINT);
        $terms = json_decode($terms, true);
        
        foreach ($terms as $item) { //foreach element in $arr
            $term_id = $item['term_id'];
            
            $cat_thumb_id  = get_woocommerce_term_meta($term_id, 'thumbnail_id', true);
            $cat_thumb_url = wp_get_attachment_thumb_url($cat_thumb_id);
            if ($cat_thumb_url === false) {
                $cat_thumb_url = NULL;
            }
            $item['thumbnail'] = $cat_thumb_url;
            $CatData[]         = $item;
            
        }
        return $CatData;
    }
    
    function get_variation_data($product)
    {
        $variations = array();
        
        foreach ($product->get_children() as $child_id) {
            $variation = wc_get_product($child_id);
            if (!$variation || !$variation->exists()) {
                continue;
            }
            
            $variations[] = array(
                'id' => $variation->get_id(),
                'date_created' => wc_rest_prepare_date_response($variation->get_date_created()),
                'date_modified' => wc_rest_prepare_date_response($variation->get_date_modified()),
                'permalink' => $variation->get_permalink(),
                'sku' => $variation->get_sku(),
                'price' => $variation->get_price(),
                'regular_price' => $variation->get_regular_price(),
                'sale_price' => $variation->get_sale_price(),
                'date_on_sale_from' => $variation->get_date_on_sale_from() ? date('Y-m-d', $variation->get_date_on_sale_from()->getTimestamp()) : '',
                'date_on_sale_to' => $variation->get_date_on_sale_to() ? date('Y-m-d', $variation->get_date_on_sale_to()->getTimestamp()) : '',
                'on_sale' => $variation->is_on_sale(),
                'purchasable' => $variation->is_purchasable(),
                'visible' => $variation->is_visible(),
                'virtual' => $variation->is_virtual(),
                'downloadable' => $variation->is_downloadable(),
                'downloads' => $this->get_downloads($variation),
                'download_limit' => '' !== $variation->get_download_limit() ? (int) $variation->get_download_limit() : -1,
                'download_expiry' => '' !== $variation->get_download_expiry() ? (int) $variation->get_download_expiry() : -1,
                'tax_status' => $variation->get_tax_status(),
                'tax_class' => $variation->get_tax_class(),
                'manage_stock' => $variation->managing_stock(),
                'stock_quantity' => $variation->get_stock_quantity(),
                'in_stock' => $variation->is_in_stock(),
                'backorders' => $variation->get_backorders(),
                'backorders_allowed' => $variation->backorders_allowed(),
                'backordered' => $variation->is_on_backorder(),
                'weight' => $variation->get_weight(),
                'dimensions' => array(
                    'length' => $variation->get_length(),
                    'width' => $variation->get_width(),
                    'height' => $variation->get_height()
                ),
                'shipping_class' => $variation->get_shipping_class(),
                'shipping_class_id' => $variation->get_shipping_class_id(),
                'image' => $this->get_images($variation),
                'attributes' => $this->get_attributes($variation)
            );
        }
        
        return $variations;
    }
    
    function Product()
    {
        
        if (isset($_GET['id'])) {
            $IDs = $_GET['id'];
        }
        
        $all_ids = explode(',', $IDs);
        
        $a = 0;
        foreach ($all_ids as $id) {
                 $product = wc_get_product($id);
                 $data = array(
                'id' => $product->get_id(),
                'name' => $product->get_name(),
                'slug' => $product->get_slug(),
                'permalink' => $product->get_permalink(),
                'date_created' => wc_rest_prepare_date_response($product->get_date_created()),
                'date_modified' => wc_rest_prepare_date_response($product->get_date_modified()),
                'type' => $product->get_type(),
                'status' => $product->get_status(),
                'featured' => $product->is_featured(),
                'catalog_visibility' => $product->get_catalog_visibility(),
                'description' => strip_tags($product->get_description()),
                'short_description' => strip_tags($product->get_short_description()),
                'sku' => $product->get_sku(),
                'price' => $product->get_price(),
                'regular_price' => $product->get_regular_price(),
                'sale_price' => $product->get_sale_price() ? $product->get_sale_price() : '',
                'date_on_sale_from' => $product->get_date_on_sale_from() ? date('Y-m-d', $product->get_date_on_sale_from()->getTimestamp()) : '',
                'date_on_sale_to' => $product->get_date_on_sale_to() ? date('Y-m-d', $product->get_date_on_sale_to()->getTimestamp()) : '',
                'price_html' => strip_tags($product->get_price_html()),
                'on_sale' => $product->is_on_sale(),
                'purchasable' => $product->is_purchasable(),
                'total_sales' => $product->get_total_sales(),
                'virtual' => $product->is_virtual(),
                'downloadable' => $product->is_downloadable(),
                'downloads' => $this->get_downloads($product),
                'download_limit' => $product->get_download_limit(),
                'download_expiry' => $product->get_download_expiry(),
                'download_type' => 'standard',
                'external_url' => $product->is_type('external') ? $product->get_product_url() : '',
                'button_text' => $product->is_type('external') ? $product->get_button_text() : '',
                'tax_status' => $product->get_tax_status(),
                'tax_class' => $product->get_tax_class(),
                'manage_stock' => $product->managing_stock(),
                'stock_quantity' => $product->get_stock_quantity(),
                'in_stock' => $product->is_in_stock(),
                'backorders' => $product->get_backorders(),
                'backorders_allowed' => $product->backorders_allowed(),
                'backordered' => $product->is_on_backorder(),
                'sold_individually' => $product->is_sold_individually(),
                'weight' => $product->get_weight(),
                'shipping_required' => $product->needs_shipping(),
                'shipping_taxable' => $product->is_shipping_taxable(),
                'shipping_class' => $product->get_shipping_class(),
                'shipping_class_id' => $product->get_shipping_class_id(),
                'reviews_allowed' => $product->get_reviews_allowed(),
                'average_rating' => wc_format_decimal($product->get_average_rating(), 2),
                'rating_count' => $product->get_rating_count(),
                'related_ids' => array_map('absint', array_values(wc_get_related_products($product->get_id()))),
                'upsell_ids' => array_map('absint', $product->get_upsell_ids()),
                'cross_sell_ids' => array_map('absint', $product->get_cross_sell_ids()),
                'parent_id' => $product->get_parent_id(),
                'purchase_note' => wpautop(do_shortcode(wp_kses_post($product->get_purchase_note()))),
                'categories' => $this->categories_data($id),
                'tags' => $this->get_taxonomy_terms($product, 'tag'),
                'images' => $this->get_images($product),
                'attributes' => $this->get_attributes($product),
                'default_attributes' => $this->get_default_attributes($product),
                'variations' => $this->get_variation_data($product),
                'grouped_products' => array(),
                'vendor_id' => get_post_field('post_author', $id),
                'menu_order' => $product->get_menu_order(),
                'meta_data' => $product->get_meta_data()
            );
            //converting data to json object
            $data            = json_encode($data);
            //add each data id to array
            $product_array[] = json_decode($data, true);
            
        }
        $json = json_encode($product_array);
        echo $json;
    }
}

$productbyId = new ProductById();
$funcname    = "Product";
$productbyId->$funcname();

?>