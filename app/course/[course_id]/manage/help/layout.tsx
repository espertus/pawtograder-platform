import { Box, Flex } from "@chakra-ui/react";
import HelpRequestList from "./HelpRequestList";
export default function HelpManageLayout({ children, params }: Readonly<{
    children: React.ReactNode;
    params: Promise<{ course_id: string }>
}>) {
    return (
        <Box>
             <Flex flex="1">
                <Box w="314px"
                    borderRight="1px solid"
                    borderColor="border.emphasized"
                    pt="4">
                    <HelpRequestList />
                </Box>
                <Box p="4" overflowY="auto" width="100%" height="100vh">
                    {children}
                </Box>
            </Flex>
        </Box>
    )
}