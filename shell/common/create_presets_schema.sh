#file must be sourced

logger "INFO: Creating DB presets for $DB (if necessary)"

$MYSQL "
CREATE TABLE IF NOT EXISTS \`filter_presets\` (
 \`id_preset\` int(11) NOT NULL AUTO_INCREMENT,
 \`selected_tool\` varchar(255) NOT NULL,
 \`URL\` longtext NOT NULL,
 \`default_preset\` int(1) NOT NULL DEFAULT 0,
 \`short_name\` varchar(255) NOT NULL,
 \`description\` longtext,
 PRIMARY KEY (\`id_preset\`),
 UNIQUE (\`selected_tool\`,\`short_name\`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

"

$MYSQL "DROP TABLE IF EXISTS \`filters_presets\`;"

###############################################################################
# Presets for Local Deployment

$MYSQL "REPLACE INTO \`filter_presets\` (\`short_name\`,\`selected_tool\`,\`URL\`,\`default_preset\`,\`description\`) VALUES ('HDD vs SSD','Config Improvement','/configimprovement?benchs[]=sort&benchs[]=terasort&benchs[]=wordcount&disks[]=HD2&disks[]=HD3&disks[]=HD4&disks[]=HD5&disks[]=HDD&disks[]=SS2&disks[]=SSD&bench_types[]=HiBench&vm_sizes[]=None&filters[]=valid&filters[]=filters&allunchecked=&datefrom=&dateto=&minexetime=50&maxexetime=',1,'HDD vs SSD comparison');"
$MYSQL "REPLACE INTO \`filter_presets\` (\`short_name\`,\`selected_tool\`,\`URL\`,\`default_preset\`,\`description\`) VALUES ('VM Size','Parameter Evaluation','/parameval?parameval=vm_size&minexecs=&benchs[]=sort&benchs[]=terasort&benchs[]=wordcount&bench_types[]=HDI&bench_types[]=HiBench&vm_sizes[]=None&filters[]=valid&filters[]=filters&allunchecked=&datefrom=&dateto=&minexetime=50&maxexetime=',1,'Evaluation by size');"
$MYSQL "REPLACE INTO \`filter_presets\` (\`short_name\`,\`selected_tool\`,\`URL\`,\`default_preset\`,\`description\`) VALUES ('HDI vs IaaS Remotes','Clusters Cost Evaluation','/costperfclustereval?benchs[]=terasort&disks[]=RL1&disks[]=RL2&disks[]=RL3&disks[]=RL4&disks[]=RL5&disks[]=RL6&disks[]=RR1&disks[]=RR2&disks[]=RR3&disks[]=RR4&disks[]=RR5&disks[]=RR6&disks[]=RS3&bench_types[]=HDI&bench_types[]=HiBench&types[]=IaaS&types[]=PaaS&filters[]=valid&filters[]=filters&allunchecked=&selected-groups=&datefrom=&dateto=&minexetime=50&maxexetime=&cost_hour[1]=1.500&cost_remote[1]=0.000&cost_SSD[1]=0.350&cost_IB[1]=0.390&cost_hour[2]=3.520&cost_remote[2]=0.042&cost_SSD[2]=0.000&cost_IB[2]=0.000&cost_hour[3]=7.920&cost_remote[3]=0.042&cost_SSD[3]=0.000&cost_IB[3]=0.000&cost_hour[4]=7.920&cost_remote[4]=0.042&cost_SSD[4]=0.000&cost_IB[4]=0.000&cost_hour[5]=3.520&cost_remote[5]=0.042&cost_SSD[5]=0.000&cost_IB[5]=0.000&cost_hour[6]=2.664&cost_remote[6]=0.042&cost_SSD[6]=0.000&cost_IB[6]=0.000&cost_hour[8]=1.584&cost_remote[8]=0.042&cost_SSD[8]=0.000&cost_IB[8]=0.000&cost_hour[10]=7.500&cost_remote[10]=0.000&cost_SSD[10]=0.000&cost_IB[10]=0.000&cost_hour[12]=7.500&cost_remote[12]=0.000&cost_SSD[12]=0.000&cost_IB[12]=0.000&cost_hour[14]=3.168&cost_remote[14]=0.042&cost_SSD[14]=0.000&cost_IB[14]=0.000&cost_hour[15]=3.960&cost_remote[15]=0.042&cost_SSD[15]=0.000&cost_IB[15]=0.000&cost_hour[16]=2.664&cost_remote[16]=0.042&cost_SSD[16]=0.000&cost_IB[16]=0.000&cost_hour[19]=4.995&cost_remote[19]=0.042&cost_SSD[19]=0.000&cost_IB[19]=0.000&cost_hour[20]=1.920&cost_remote[20]=0.000&cost_SSD[20]=0.000&cost_IB[20]=0.000&cost_hour[21]=3.500&cost_remote[21]=0.200&cost_SSD[21]=0.700&cost_IB[21]=0.800&cost_hour[22]=9.500&cost_remote[22]=0.000&cost_SSD[22]=0.000&cost_IB[22]=0.000&cost_hour[23]=4.120&cost_remote[23]=0.000&cost_SSD[23]=0.000&cost_IB[23]=0.000&cost_hour[24]=5.760&cost_remote[24]=0.000&cost_SSD[24]=0.000&cost_IB[24]=0.000&cost_hour[25]=10.880&cost_remote[25]=0.000&cost_SSD[25]=0.000&cost_IB[25]=0.000&cost_hour[26]=17.730&cost_remote[26]=0.042&cost_SSD[26]=0.000&cost_IB[26]=0.000&cost_hour[28]=0.792&cost_remote[28]=0.042&cost_SSD[28]=0.000&cost_IB[28]=0.000&cost_hour[29]=6.768&cost_remote[29]=0.042&cost_SSD[29]=0.000&cost_IB[29]=0.000&cost_hour[30]=9.990&cost_remote[30]=0.042&cost_SSD[30]=0.000&cost_IB[30]=0.000&cost_hour[33]=9.990&cost_remote[33]=0.042&cost_SSD[33]=0.000&cost_IB[33]=0.000&cost_hour[34]=1.584&cost_remote[34]=0.042&cost_SSD[34]=0.000&cost_IB[34]=0.000&cost_hour[35]=1.584&cost_remote[35]=0.042&cost_SSD[35]=0.000&cost_IB[35]=0.000&cost_hour[36]=7.920&cost_remote[36]=0.042&cost_SSD[36]=0.000&cost_IB[36]=0.000&cost_hour[38]=5.440&cost_remote[38]=0.000&cost_SSD[38]=0.000&cost_IB[38]=0.000',0,'HDI versus IaaS remotes configurations');"
$MYSQL "REPLACE INTO \`filter_presets\` (\`short_name\`,\`selected_tool\`,\`URL\`,\`default_preset\`,\`description\`) VALUES ('HDI vs IaaS Remotes','Cost-Effectiveness of clusters','/clustercosteffectiveness?benchs[]=terasort&disks[]=RL1&disks[]=RL2&disks[]=RL3&disks[]=RL4&disks[]=RL5&disks[]=RL6&disks[]=RR1&disks[]=RR2&disks[]=RR3&disks[]=RR4&disks[]=RR5&disks[]=RR6&disks[]=RS3&bench_types[]=HDI&bench_types[]=HiBench&types[]=IaaS&types[]=PaaS&filters[]=valid&filters[]=filters&allunchecked=&selected-groups=&datefrom=&dateto=&minexetime=50&maxexetime=&cost_hour[1]=1.500&cost_remote[1]=0.000&cost_SSD[1]=0.350&cost_IB[1]=0.390&cost_hour[2]=3.520&cost_remote[2]=0.042&cost_SSD[2]=0.000&cost_IB[2]=0.000&cost_hour[3]=7.920&cost_remote[3]=0.042&cost_SSD[3]=0.000&cost_IB[3]=0.000&cost_hour[4]=7.920&cost_remote[4]=0.042&cost_SSD[4]=0.000&cost_IB[4]=0.000&cost_hour[5]=3.520&cost_remote[5]=0.042&cost_SSD[5]=0.000&cost_IB[5]=0.000&cost_hour[6]=2.664&cost_remote[6]=0.042&cost_SSD[6]=0.000&cost_IB[6]=0.000&cost_hour[8]=1.584&cost_remote[8]=0.042&cost_SSD[8]=0.000&cost_IB[8]=0.000&cost_hour[10]=7.500&cost_remote[10]=0.000&cost_SSD[10]=0.000&cost_IB[10]=0.000&cost_hour[12]=7.500&cost_remote[12]=0.000&cost_SSD[12]=0.000&cost_IB[12]=0.000&cost_hour[14]=3.168&cost_remote[14]=0.042&cost_SSD[14]=0.000&cost_IB[14]=0.000&cost_hour[15]=3.960&cost_remote[15]=0.042&cost_SSD[15]=0.000&cost_IB[15]=0.000&cost_hour[16]=2.664&cost_remote[16]=0.042&cost_SSD[16]=0.000&cost_IB[16]=0.000&cost_hour[19]=4.995&cost_remote[19]=0.042&cost_SSD[19]=0.000&cost_IB[19]=0.000&cost_hour[20]=1.920&cost_remote[20]=0.000&cost_SSD[20]=0.000&cost_IB[20]=0.000&cost_hour[21]=3.500&cost_remote[21]=0.200&cost_SSD[21]=0.700&cost_IB[21]=0.800&cost_hour[22]=9.500&cost_remote[22]=0.000&cost_SSD[22]=0.000&cost_IB[22]=0.000&cost_hour[23]=4.120&cost_remote[23]=0.000&cost_SSD[23]=0.000&cost_IB[23]=0.000&cost_hour[24]=5.760&cost_remote[24]=0.000&cost_SSD[24]=0.000&cost_IB[24]=0.000&cost_hour[25]=10.880&cost_remote[25]=0.000&cost_SSD[25]=0.000&cost_IB[25]=0.000&cost_hour[26]=17.730&cost_remote[26]=0.042&cost_SSD[26]=0.000&cost_IB[26]=0.000&cost_hour[28]=0.792&cost_remote[28]=0.042&cost_SSD[28]=0.000&cost_IB[28]=0.000&cost_hour[29]=6.768&cost_remote[29]=0.042&cost_SSD[29]=0.000&cost_IB[29]=0.000&cost_hour[30]=9.990&cost_remote[30]=0.042&cost_SSD[30]=0.000&cost_IB[30]=0.000&cost_hour[33]=9.990&cost_remote[33]=0.042&cost_SSD[33]=0.000&cost_IB[33]=0.000&cost_hour[34]=1.584&cost_remote[34]=0.042&cost_SSD[34]=0.000&cost_IB[34]=0.000&cost_hour[35]=1.584&cost_remote[35]=0.042&cost_SSD[35]=0.000&cost_IB[35]=0.000&cost_hour[36]=7.920&cost_remote[36]=0.042&cost_SSD[36]=0.000&cost_IB[36]=0.000&cost_hour[38]=5.440&cost_remote[38]=0.000&cost_SSD[38]=0.000&cost_IB[38]=0.000',0,'HDI versus IaaS remotes configurations');"
$MYSQL "REPLACE INTO \`filter_presets\` (\`short_name\`,\`selected_tool\`,\`URL\`,\`default_preset\`,\`description\`) VALUES ('HDI vs IaaS Remotes','Best Clusters Cost Evaluation','/bestcostperfclustereval?benchs[]=terasort&disks[]=RL1&disks[]=RL2&disks[]=RL3&disks[]=RL4&disks[]=RL5&disks[]=RL6&disks[]=RR1&disks[]=RR2&disks[]=RR3&disks[]=RR4&disks[]=RR5&disks[]=RR6&disks[]=RS3&bench_types[]=HDI&bench_types[]=HiBench&types[]=IaaS&types[]=PaaS&filters[]=valid&filters[]=filters&allunchecked=&selected-groups=&datefrom=&dateto=&minexetime=50&maxexetime=&cost_hour[1]=1.500&cost_remote[1]=0.000&cost_SSD[1]=0.350&cost_IB[1]=0.390&cost_hour[2]=3.520&cost_remote[2]=0.042&cost_SSD[2]=0.000&cost_IB[2]=0.000&cost_hour[3]=7.920&cost_remote[3]=0.042&cost_SSD[3]=0.000&cost_IB[3]=0.000&cost_hour[4]=7.920&cost_remote[4]=0.042&cost_SSD[4]=0.000&cost_IB[4]=0.000&cost_hour[5]=3.520&cost_remote[5]=0.042&cost_SSD[5]=0.000&cost_IB[5]=0.000&cost_hour[6]=2.664&cost_remote[6]=0.042&cost_SSD[6]=0.000&cost_IB[6]=0.000&cost_hour[8]=1.584&cost_remote[8]=0.042&cost_SSD[8]=0.000&cost_IB[8]=0.000&cost_hour[10]=7.500&cost_remote[10]=0.000&cost_SSD[10]=0.000&cost_IB[10]=0.000&cost_hour[12]=7.500&cost_remote[12]=0.000&cost_SSD[12]=0.000&cost_IB[12]=0.000&cost_hour[14]=3.168&cost_remote[14]=0.042&cost_SSD[14]=0.000&cost_IB[14]=0.000&cost_hour[15]=3.960&cost_remote[15]=0.042&cost_SSD[15]=0.000&cost_IB[15]=0.000&cost_hour[16]=2.664&cost_remote[16]=0.042&cost_SSD[16]=0.000&cost_IB[16]=0.000&cost_hour[19]=4.995&cost_remote[19]=0.042&cost_SSD[19]=0.000&cost_IB[19]=0.000&cost_hour[20]=1.920&cost_remote[20]=0.000&cost_SSD[20]=0.000&cost_IB[20]=0.000&cost_hour[21]=3.500&cost_remote[21]=0.200&cost_SSD[21]=0.700&cost_IB[21]=0.800&cost_hour[22]=9.500&cost_remote[22]=0.000&cost_SSD[22]=0.000&cost_IB[22]=0.000&cost_hour[23]=4.120&cost_remote[23]=0.000&cost_SSD[23]=0.000&cost_IB[23]=0.000&cost_hour[24]=5.760&cost_remote[24]=0.000&cost_SSD[24]=0.000&cost_IB[24]=0.000&cost_hour[25]=10.880&cost_remote[25]=0.000&cost_SSD[25]=0.000&cost_IB[25]=0.000&cost_hour[26]=17.730&cost_remote[26]=0.042&cost_SSD[26]=0.000&cost_IB[26]=0.000&cost_hour[28]=0.792&cost_remote[28]=0.042&cost_SSD[28]=0.000&cost_IB[28]=0.000&cost_hour[29]=6.768&cost_remote[29]=0.042&cost_SSD[29]=0.000&cost_IB[29]=0.000&cost_hour[30]=9.990&cost_remote[30]=0.042&cost_SSD[30]=0.000&cost_IB[30]=0.000&cost_hour[33]=9.990&cost_remote[33]=0.042&cost_SSD[33]=0.000&cost_IB[33]=0.000&cost_hour[34]=1.584&cost_remote[34]=0.042&cost_SSD[34]=0.000&cost_IB[34]=0.000&cost_hour[35]=1.584&cost_remote[35]=0.042&cost_SSD[35]=0.000&cost_IB[35]=0.000&cost_hour[36]=7.920&cost_remote[36]=0.042&cost_SSD[36]=0.000&cost_IB[36]=0.000&cost_hour[38]=5.440&cost_remote[38]=0.000&cost_SSD[38]=0.000&cost_IB[38]=0.000',0,'HDI versus IaaS remotes configurations');"
$MYSQL "REPLACE INTO \`filter_presets\` (\`short_name\`,\`selected_tool\`,\`URL\`,\`default_preset\`,\`description\`) VALUES ('Azure number of nodes evaluation','Number of Nodes Evaluation','/nodeseval?benchs[]=wordcount&bench_types[]=HiBench&vm_sizes[]=A2&vm_sizes[]=A3&vm_sizes[]=A4&vm_sizes[]=A6&vm_sizes[]=A7&vm_sizes[]=A8&vm_sizes[]=D4&types[]=IaaS&filters[]=valid&filters[]=filters&allunchecked=&selected-groups=&datefrom=&dateto=&minexetime=50&maxexetime=',1,'Azure number of nodes evaluation');"
$MYSQL "REPLACE INTO \`filter_presets\` (\`short_name\`,\`selected_tool\`,\`URL\`,\`default_preset\`,\`description\`) VALUES ('HDI number of nodes','Number of Nodes Evaluation','/nodeseval?benchs[]=wordcount&bench_types[]=HiBench&types[]=PaaS&filters[]=valid&filters[]=filters&allunchecked=&selected-groups=&datefrom=&dateto=&minexetime=50&maxexetime=',0,'HDI number of nodes evaluation');"
$MYSQL "REPLACE INTO \`filter_presets\` (\`short_name\`,\`selected_tool\`,\`URL\`,\`default_preset\`,\`description\`) VALUES ('MLPrediction Default','mlprediction','/mlprediction?benchs[]=terasort&disks[]=HDD&disks[]=SSD&comps[]=0&replications[]=1&iofilebufs[]=32768&iofilebufs[]=65536&iofilebufs[]=131072&learn=regtree&umodel=1&allunchecked=&selected-groups=&datefrom=&dateto=&minexetime=&maxexetime=',1,'MLPrediction Default');"
$MYSQL "REPLACE INTO \`filter_presets\` (\`short_name\`,\`selected_tool\`,\`URL\`,\`default_preset\`,\`description\`) VALUES ('MLOutliers Default','mloutliers','/mloutliers?benchs[]=terasort&disks[]=HDD&disks[]=SSD&comps[]=0&replications[]=1&iofilebufs[]=32768&iofilebufs[]=65536&iofilebufs[]=131072&current_model=c26c7cb6440534304333eb1d66cd33fc&sigma=1&allunchecked=&selected-groups=&datefrom=&dateto=&minexetime=&maxexetime=',1,'MLOutliers Default');"
$MYSQL "REPLACE INTO \`filter_presets\` (\`short_name\`,\`selected_tool\`,\`URL\`,\`default_preset\`,\`description\`) VALUES ('MLSummaries Default','mlsummaries','/mlsummaries?benchs[]=sort&benchs[]=terasort&benchs[]=wordcount&disks[]=HDD&disks[]=SSD&feature=Benchmark&allunchecked=&selected-groups=&datefrom=&dateto=&minexetime=&maxexetime=',1,'MLSummaries Default');"
$MYSQL "REPLACE INTO \`filter_presets\` (\`short_name\`,\`selected_tool\`,\`URL\`,\`default_preset\`,\`description\`) VALUES ('MLDataCollapse Default','mldatacollapse','/mldatacollapse?benchs[]=bayes&benchs[]=sort&benchs[]=terasort&benchs[]=wordcount&disks[]=HDD&disks[]=SSD&comps[]=0&replications[]=1&iofilebufs[]=65536&iofilebufs[]=131072&allunchecked=&selected-groups=&datefrom=&dateto=&minexetime=&maxexetime=',1,'MLDataCollapse Default');"
$MYSQL "REPLACE INTO \`filter_presets\` (\`short_name\`,\`selected_tool\`,\`URL\`,\`default_preset\`,\`description\`) VALUES ('MLCrossVariables Default','mlcrossvar','/mlcrossvar?variable1=maps&variable2=exe_time&benchs[]=terasort&disks[]=HDD&disks[]=SSD&comps[]=0&replications[]=1&iofilebufs[]=32768&iofilebufs[]=65536&iofilebufs[]=131072&allunchecked=&selected-groups=&datefrom=&dateto=&minexetime=&maxexetime=',1,'MLCrossVariables Default');"
$MYSQL "REPLACE INTO \`filter_presets\` (\`short_name\`,\`selected_tool\`,\`URL\`,\`default_preset\`,\`description\`) VALUES ('MLCrossVariables3D Default','mlcrossvar3d','/mlcrossvar3d?variable1=maps&variable2=net&benchs[]=terasort&disks[]=HDD&disks[]=SSD&comps[]=0&replications[]=1&iofilebufs[]=32768&iofilebufs[]=65536&iofilebufs[]=131072&allunchecked=&selected-groups=&datefrom=&dateto=&minexetime=&maxexetime=',1,'MLCrossVariables3D Default');"
$MYSQL "REPLACE INTO \`filter_presets\` (\`short_name\`,\`selected_tool\`,\`URL\`,\`default_preset\`,\`description\`) VALUES ('MLCrossVariables3DFA Default','mlcrossvar3dfa','/mlcrossvar3dfa?variable1=maps&variable2=net&benchs[]=terasort&id_clusters[]=1&disks[]=HDD&disks[]=SSD&comps[]=0&replications[]=1&blk_sizes[]=128&iofilebufs[]=32768&iofilebufs[]=65536&iofilebufs[]=131072&current_model=&unseen=1&allunchecked=&selected-groups=&datefrom=&dateto=&minexetime=&maxexetime=',1,'MLCrossVariables3DFA Default');"
$MYSQL "REPLACE INTO \`filter_presets\` (\`short_name\`,\`selected_tool\`,\`URL\`,\`default_preset\`,\`description\`) VALUES ('MLMinConfigs Default','mlminconfigs','/mlminconfigs?benchs[]=terasort&disks[]=HDD&disks[]=SSD&comps[]=0&replications[]=1&iofilebufs[]=32768&iofilebufs[]=65536&iofilebufs[]=131072&learn=regtree&umodel=1&allunchecked=&selected-groups=&datefrom=&dateto=&minexetime=&maxexetime=',1,'MLMinConfigs Default');"
$MYSQL "REPLACE INTO \`filter_presets\` (\`short_name\`,\`selected_tool\`,\`URL\`,\`default_preset\`,\`description\`) VALUES ('MLFindAttrs Default','mlfindattributes','/mlfindattributes?benchs[]=terasort&id_clusters[]=1&disks[]=HDD&disks[]=SSD&mapss[]=4&comps[]=0&replications[]=1&blk_sizes[]=128&iosfs[]=10&iofilebufs[]=65536&iofilebufs[]=131072&current_model=ee7c939fefa656a3f82f80002ed39c1d&unseen=1&allunchecked=&selected-groups=&datefrom=&dateto=&minexetime=&maxexetime=',1,'MLFindAttrs Default');"
$MYSQL "REPLACE INTO \`filter_presets\` (\`short_name\`,\`selected_tool\`,\`URL\`,\`default_preset\`,\`description\`) VALUES ('MLParamEval Default','mlparameval','/mlparameval?benchs[]=terasort&id_clusters[]=1&disks[]=HDD&disks[]=SSD&comps[]=0&replications[]=1&iofilebufs[]=32768&iofilebufs[]=65536&iofilebufs[]=131072&current_model=c26c7cb6440534304333eb1d66cd33fc&allunchecked=&selected-groups=&datefrom=&dateto=&minexetime=&maxexetime=',1,'MLParamEval Default');"
$MYSQL "REPLACE INTO \`filter_presets\` (\`short_name\`,\`selected_tool\`,\`URL\`,\`default_preset\`,\`description\`) VALUES ('MLPrecision Default','mlprecision','/mlprecision?benchs[]=terasort&id_clusters[]=2&id_clusters[]=3&id_clusters[]=4&allunchecked=&selected-groups=&datefrom=&dateto=&minexetime=&maxexetime=',1,'MLPrecision Default');"


