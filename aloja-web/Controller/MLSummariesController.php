<?php

namespace alojaweb\Controller;

use alojaweb\inc\HighCharts;
use alojaweb\inc\Utils;
use alojaweb\inc\DBUtils;
use alojaweb\inc\MLUtils;

class MLSummariesController extends AbstractController
{
	public function __construct($container)
	{
		parent::__construct($container);

		//All this screens are using this custom filters
		$this->removeFilters(array('prediction_model','upred','uobsr','warning','outlier','money'));
	}

	public function mlsummariesAction()
	{
		$displaydata = $separate_feat = $instance = $model_info = $slice_info = '';
		$param_names = $param_names_additional = array();
		try
		{
			$dbml = MLUtils::getMLDBConnection($this->container->get('config')['db_conn_chain'], $this->container->get('config')['mysql_user'], $this->container->get('config')['mysql_pwd']);
			$db = $this->container->getDBUtils();

			$this->filters->removeFilters(array('upred','uobsr'));
			$this->filters->removeFIltersFromGroup("MLearning",array('upred','uobsr'));
			$this->buildFilters(array(
				'bench_type' => array('default' => array('HiBench'), 'type' => 'selectOne'),
				'feature' => array(
					'type' => 'selectOne',
					'default' => array('joined'),
					'label' => 'Separate by: ',
					'generateChoices' => function() {
						return array('joined','Benchmark','Net',
							'Disk','Maps','IO.SFac',
							'Rep','IO.FBuf','Comp',
							'Blk.size','Cluster'
						);
					},
					'beautifier' => function($value) {
						$labels = array('joined' => 'None','Benchmark' => 'Benchmarks',
							'Net' => 'Networks', 'Disk' => 'Disks','Maps' => 'Maps',
							'IO.SFac' => 'IO Sort Factor', 'Rep' => 'Replication',
							'Rep' => 'Replication','IO.FBuf' => 'IO File Buffer',
							'Comp' => 'Compressions', 'Blk.size' => 'Block sizes',
							'Cluster' => 'Clusters'
						);
						return $labels[$value];
					},
					'parseFunction' => function() {
						$choice = isset($_GET['feature']) ? $_GET['feature'] : array('joined');
						return array('whereClause' => '', 'currentChoice' => $choice);
					},
					'filterGroup' => 'MLearning'
				)
			));
			$this->buildFilterGroups(array('MLearning' => array('label' => 'Grouping Options', 'tabOpenDefault' => true)));

			$where_configs = $this->filters->getWhereClause();

			$param_names = array('bench','net','disk','maps','iosf','replication','iofilebuf','comp','blk_size','id_cluster','datanodes','bench_type','vm_size','vm_cores','vm_RAM','type','hadoop_version','provider','vm_OS'); // Order is important
			$params = $this->filters->getFiltersSelectedChoices($param_names);
			foreach ($param_names as $p) if (!is_null($params[$p]) && is_array($params[$p])) sort($params[$p]);

			$param_names_additional = array('datefrom','dateto','minexetime','maxexetime','valid','filter'); // Order is important
			$params_additional = $this->filters->getFiltersSelectedChoices($param_names_additional);

			$feature = $this->filters->getFiltersSelectedChoices(array('feature'));
			$separate_feat = $feature['feature'];

			// compose instance
			$instance = MLUtils::generateSimpleInstance($this->filters,$param_names, $params, true);
			$model_info = MLUtils::generateModelInfo($this->filters,$param_names, $params, true);
			$slice_info = MLUtils::generateDatasliceInfo($this->filters,$param_names_additional, $params_additional);

			$config = $model_info.' '.$separate_feat.' '.$slice_info.' SUMMARY';

			$cache_ds = getcwd().'/cache/ml/'.md5($config).'-cache.csv';

			$is_cached_mysql = $dbml->query("SELECT count(*) as num FROM aloja_ml.summaries WHERE id_summaries = '".md5($config)."'");
			$tmp_result = $is_cached_mysql->fetch();
			$is_cached = ($tmp_result['num'] > 0);

			if (!$is_cached)
			{
				// get headers for csv
				$header_names = array(
					'e.id_exec' => 'ID','e.bench' => 'Benchmark','e.exe_time' => 'Exe.Time','e.net' => 'Net','e.disk' => 'Disk','e.maps' => 'Maps','e.iosf' => 'IO.SFac',
					'e.replication' => 'Rep','e.iofilebuf' => 'IO.FBuf','e.comp' => 'Comp','e.blk_size' => 'Blk.size','e.id_cluster' => 'Cluster','c.name' => 'Cl.Name',
					'c.datanodes' => 'Datanodes','c.headnodes' => 'Headnodes','c.vm_OS' => 'VM.OS','c.vm_cores' => 'VM.Cores','c.vm_RAM' => 'VM.RAM',
					'c.provider' => 'Provider','c.vm_size' => 'VM.Size','c.type' => 'Service.Type','e.bench_type' => 'Bench.Type','e.hadoop_version' => 'Hadoop.Version',
					'IFNULL(e.datasize,0)' =>'Datasize','e.scale_factor' => 'Scale.Factor'
				);

				// dump the result to csv
			    	$query="SELECT ".implode(",",array_keys($header_names))." FROM aloja2.execs e LEFT JOIN aloja2.clusters c ON e.id_cluster = c.id_cluster LEFT JOIN aloja_ml.predictions p USING (id_exec) WHERE e.hadoop_version IS NOT NULL".$where_configs.";";
			    	$rows = $db->get_rows ( $query );
				if (empty($rows)) throw new \Exception('No data matches with your critteria.');

				$fp = fopen($cache_ds, 'w');
				fputcsv($fp,array_values($header_names),',','"');
			    	foreach($rows as $row)
				{
					$row['id_cluster'] = "Cl".$row['id_cluster'];	// Cluster is numerically codified...
					$row['comp'] = "Cmp".$row['comp'];		// Compression is numerically codified...
					fputcsv($fp, array_values($row),',','"');
				}

				// launch query
				$command = 'cd '.getcwd().'/cache/ml; ../../resources/aloja_cli.r -m aloja_print_summaries -d '.$cache_ds.' -p '.(($separate_feat!='joined')?'sname='.$separate_feat.':':'').'fprint='.md5($config).':fwidth=1000:html=1'; #fwidth=135
				$output = shell_exec($command);

				// Save to DB
				if (($handle = fopen(getcwd().'/cache/ml/'.md5($config).'-summary.data', 'r')) !== FALSE)
				{
					$displaydata = "";
					while (($data = fgets($handle)) !== FALSE)
					{
						$displaydata = $displaydata.$data;
					}
					fclose($handle);

					$displaydata = str_replace('\'','\\\'',$displaydata);

					// register model to DB
					$query = "INSERT INTO aloja_ml.summaries (id_summaries,instance,model,dataslice,summary)";
					$query = $query." VALUES ('".md5($config)."','".$instance."','".substr($model_info,1)."','".$slice_info."','".$displaydata."');";
					if ($dbml->query($query) === FALSE) throw new \Exception('Error when saving model into DB');
				}

				// Remove temporal files
				$output = shell_exec('rm -f '.getcwd().'/cache/ml/'.md5($config).'-summary.data');
				$output = shell_exec('rm -f '.getcwd().'/cache/ml/'.md5($config).'-cache.csv');
			}

			// Read results of the DB
			$is_cached_mysql = $dbml->query("SELECT summary FROM aloja_ml.summaries WHERE id_summaries = '".md5($config)."' LIMIT 1");
			$tmp_result = $is_cached_mysql->fetch();
			$displaydata = $tmp_result['summary'];
		}
		catch(\Exception $e)
		{
			$this->container->getTwig ()->addGlobal ( 'message', $e->getMessage () . "\n" );
		}
		$return_params = array(
			'displaydata' => $displaydata,
			'feature' => $separate_feat,
			'instance' => $instance,
			'model_info' => $model_info,
			'slice_info' => $slice_info
		);
		foreach ($param_names as $p) $return_params[$p] = $params[$p];
		foreach ($param_names_additional as $p) $return_params[$p] = $params_additional[$p];

		return $this->render('mltemplate/mlsummaries.html.twig', $return_params);
	}
}
?>
