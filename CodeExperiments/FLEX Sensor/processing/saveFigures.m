FolderName = 'figThumb\';   % Your destination folder
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig);
  FigName   = num2str(get(FigHandle, 'Number'));
  savefig(FigHandle, fullfile(FolderName, [FigName '.fig']));
end