<?php

// Global Variables
$time = time();
$precision = '%.2f';

// Don't cache this page
header("Cache-Control: no-store, no-cache, must-revalidate");  // HTTP/1.1
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");                                    // HTTP/1.0

// Get APC Information
$mem = apc_sma_info();
$cache = apc_cache_info();
$cache_user = apc_cache_info('user', 1);

// Parse query string
$item = isset($_GET['q']) ? $_GET['q'] : '';
$verbose = isset($_GET['v']) && $_GET['v'] == true || $item == '';

// Do the work
function option($item) {
    static $value;

    if (!$item) {
        return false;
    }

    if (isset($value[$item])) {
        return $value[$item];
    }

    $mem = &$GLOBALS['mem'];
    $cache = &$GLOBALS['cache'];
    $cache_user = &$GLOBALS['cache_user'];

    switch($item) {

        case 'apcversion':
            $value[$item] = phpversion('apc');
            break;

        case 'phpversion':
            $value[$item] = phpversion();
            break;

        case 'uptime':
            $value[$item] = $GLOBALS['time'] - $cache['start_time'];
            break;

        case 'fragmentation':
            $value[$item] = fragmentation();
            break;

        case 'avail_mem':
        case 'num_seg':
        case 'seg_size':
            $value[$item] = $mem[$item];
            break;

        case 'expunges':
        case 'file_upload_progress':
        case 'locking_type':
        case 'mem_size':
        case 'memory_type':
        case 'num_entries':
        case 'num_hits':
        case 'num_inserts':
        case 'num_misses':
        case 'ttl':
            $value[$item] = $cache[$item];
            break;

        default:
            $value[$item] = 'undefined';
    }

    return $value[$item];
}

function fragmentation() {
    // Fragmentation: (freeseg - 1) / total_seg
    $nseg = $freeseg = $fragsize = $freetotal = 0;
    for ($i = 0; $i < $GLOBALS['mem']['num_seg']; $i++) {
        $ptr = 0;
        foreach ($GLOBALS['mem']['block_lists'][$i] as $block) {
            if ($block['offset'] != $ptr) {
                ++$nseg;
            }
            $ptr = $block['offset'] + $block['size'];
            /* Only consider blocks <5M for the fragmentation % */
            if ($block['size'] < (5*1024*1024)) {
                $fragsize += $block['size'];
            }
            $freetotal += $block['size'];
        }
        $freeseg += count($GLOBALS['mem']['block_lists'][$i]);
    }

    if ($freeseg > 1) {
        $frag = sprintf($GLOBALS['precision'], $fragsize / $freetotal * 100);
    } else {
        $frag = 0;
    }

    return $frag;
}

function options($options) {
    ksort($options);
    $return = '';
    foreach ($options as $option => $desc) {
        $return .= '<tr>';
        $return .= '<td><a href="' . $_SERVER['PHP_SELF'] . '?q=' . $option . '">' . $option . '</a></td>';
        $return .= '<td>' . option($option) . '</td>';
        $return .= '<td>' . $desc . '</td>';
        $return .= '</tr>';
    }
    return $return;
}

// Show the result
if ($verbose && option($item)) {
    echo '<h1>' . $item . ': ';
}

if (option($item)) {
    echo option($item);
}

if ($verbose) {
    echo '</h1><table border="1" cellpadding="5" cellspacing="0">';
    echo options(array('apcversion'             => 'APC Version',
                       'phpversion'             => 'PHP Version',
                       'avail_mem'              => 'Available Memory (B)',
                       'num_seg'                => 'Memory Segments',
                       'seg_size'               => 'Segment Size (B)',
                       'uptime'                 => 'Uptime (s)',
                       'memory_type'            => 'Memory Type',
                       'locking_type'           => 'Locking Type',
                       'ttl'                    => 'TTL (s)',
                       'file_upload_progress'   => 'File Upload Support (1=on, 0=off)',
                       'num_entries'            => 'Number of cached files',
                       'mem_size'               => 'Size of cached files (B)',
                       'num_hits'               => 'Number of cache hits',
                       'num_misses'             => 'Number of cache misses',
                       'num_inserts'            => 'Number of objects inserted into cache',
                       'expunges'               => 'Number of times cache has filled up',
                       'fragmentation'          => 'Cache fragmentation (%)',
                       ));
    echo '</table>';

}
