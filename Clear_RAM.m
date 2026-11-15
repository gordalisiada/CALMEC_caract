% Clear RAM
% Clean RAM folder
% Clean RCO
files = dir('RAM\RCO\');
    files(1:2) = [];
    dfiles = length(files);
    for d = 1:dfiles
        delete(['RAM\RCO\' files(d).name])
    end
    clear files
    % Clean CW1
    files = dir('RAM\CW1\');
    files(1:2) = [];
    dfiles = length(files);
    for d = 1:dfiles
        delete(['RAM\CW1\' files(d).name])
    end
    clear files
    % Clean CDM
    files = dir('RAM\CDM\');
    files(1:2) = [];
    dfiles = length(files);
    for d = 1:dfiles
        delete(['RAM\CDM\' files(d).name])
    end
    clear files
    % Clean alpha
    files = dir('RAM\alpha\');
    files(1:2) = [];
    dfiles = length(files);
    for d = 1:dfiles
        delete(['RAM\alpha\' files(d).name])
    end
    clear files
    % Clean Pref
    files = dir('RAM\Pref\');
    files(1:2) = [];
    dfiles = length(files);
    for d = 1:dfiles
        delete(['RAM\Pref\' files(d).name])
    end
    clear files
    % Clean Base
    files = dir('RAM\Base\');
    files(1:2) = [];
    dfiles = length(files);
    for d = 1:dfiles
        delete(['RAM\Base\' files(d).name])
    end
    clear files
    % Clean Base_Pref
    files = dir('RAM\Base_Pref\');
    files(1:2) = [];
    dfiles = length(files);
    for d = 1:dfiles
        delete(['RAM\Base_Pref\' files(d).name])
    end
    clear files
    % Clean Base_Pref0
    files = dir('RAM\Base_0\');
    files(1:2) = [];
    dfiles = length(files);
    for d = 1:dfiles
        delete(['RAM\Base_0\' files(d).name])
    end
    clear files
    % Clean Pref0
    files = dir('RAM\Pref0\');
    files(1:2) = [];
    dfiles = length(files);
    for d = 1:dfiles
        delete(['RAM\Pref0\' files(d).name])
    end
    clear files
    % Clean Final
    files = dir('RAM\Final\');
    files(1:2) = [];
    dfiles = length(files);
    for d = 1:dfiles
        delete(['RAM\Final\' files(d).name])
    end
    clear files