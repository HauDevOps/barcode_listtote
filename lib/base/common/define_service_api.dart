
import 'package:global_configuration/global_configuration.dart';

import 'common.dart';

//Get Config Api
GlobalConfiguration config = GlobalConfiguration();
final String ovEnfieldServiceUrl = config.getValue(OVEnfieldServiceUrl);